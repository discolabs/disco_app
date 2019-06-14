require 'render_anywhere'
require 'uglifier'

module DiscoApp::Concerns::RendersAssets

  extend ActiveSupport::Concern

  included do
    include RenderAnywhere
    after_commit :queue_render_asset_group_job
  end

  class_methods do
    # Ruby "macro" that allows the definition of a number of Shopify assets that
    # should be rendered and uploaded when certain attributes on the including
    # class change. This assumes that the including class (1) is an ActiveRecord
    # model that supports an `after_commit` callback; and (2) that the model has
    # a `shop` method (or attribute) that references the DiscoApp::Shop instance
    # associated with the current model.
    #
    # Options
    #
    #   assets:           Required. A list of asset templates to be rendered and
    #                     uploaded to Shopify. The order of assets matters only
    #                     in that subsequent asset templates will have access to
    #                     the public CDN url of earlier-rendered assets through
    #                     a "@public_urls" context variable.
    #
    #   triggered_by:     Optional. A list of attributes that should trigger the
    #                     re-rendering and upload of the assets defined by the
    #                     `assets` option, provided as a list of string. If
    #                     empty or nil, nothing will be triggered.
    #
    #   script_tags:      Optional. A list of assets that should have script
    #                     tags created or updated after being rendered to the
    #                     storefront.
    #
    #   minify:           Optional. Whether Javascript assets should be minified
    #                     after being rendered. Defaults to true in production
    #                     environments, false otherwise. Note that stylesheet
    #                     assets, when uploaded as .scss files, are
    #                     automatically minified by Shopify, so we don't need to
    #                     do it on our end.
    #
    def renders_assets(*asset_groups)
      options = asset_groups.last.is_a?(Hash) ? asset_groups.pop : {}
      options = renders_assets_default_options.merge(options)

      # Ensure assets, triggered by and script tag options are arrays.
      options[:assets] = options[:assets] ? Array(options[:assets]).map(&:to_sym) : []
      options[:triggered_by] = options[:triggered_by] ? Array(options[:triggered_by]).map(&:to_s) : []
      options[:script_tags] = options[:script_tags] ? Array(options[:script_tags]).map(&:to_sym) : []

      asset_groups.each do |asset_group|
        renderable_asset_groups[asset_group.to_sym] = options
      end
    end

    # Return a list of renderable asset groups, along with their options.
    def renderable_asset_groups
      @renderable_asset_groups ||= {}
    end

    # Return the default options for the `renders_assets` macro.
    def renders_assets_default_options
      {
        assets: nil,
        triggered_by: nil,
        script_tags: nil,
        minify: Rails.env.production? || Rails.env.staging?
      }
    end
  end

  # Callback, triggered after a model save. Iterates through each asset group
  # defined on the model and queues a render job if any of the changed
  # attributes are found in the asset group's triggered_by list.
  def queue_render_asset_group_job
    renderable_asset_groups.each do |asset_group, options|
      DiscoApp::RenderAssetGroupJob.perform_later(shop, self, asset_group.to_s) unless (previous_changes.keys & options[:triggered_by]).empty?
    end
  end

  # Copies the class-level hash of assets with symbol asset name as keys and
  # their corresponding options as values to the instance.
  def renderable_asset_groups
    @renderable_asset_groups ||= self.class.renderable_asset_groups.dup
  end

  # Render the specified asset group and upload the result to Shopify.
  def render_asset_group(asset_group)
    options = renderable_asset_groups[asset_group]
    public_urls = {}.with_indifferent_access

    options[:assets].each do |asset|
      # Create/replace the asset via the Shopify API.
      shopify_asset = shop.with_api_context do
        ShopifyAPI::Asset.create(
          key: asset,
          value: render_asset_group_asset(asset, public_urls, options)
        )
      end

      # Store the public URL to this asset, so that we're able to use it in
      # subsequent template renders. Adds a .css suffix to .scss assets, so that
      # we use the Shopify-compiled version of any SCSS stylesheets.
      public_urls[asset] = shopify_asset.public_url.gsub(/\.scss\?/, '.scss.css?') if shopify_asset.public_url.present?
    end

    # If we specified the creation of any script tags based on newly rendered
    # assets, do that now.
    render_asset_script_tags(options, public_urls) unless options[:script_tags].empty?
  end

  private

    # Render an individual asset within an asset group.
    def render_asset_group_asset(asset, public_urls, options)
      rendered_asset = render_asset_renderer.render_to_string(
        template: asset,
        layout: nil,
        locals: {
          :"@#{self.class.name.underscore}" => self,
          :@public_urls => public_urls
        }
      )

      if should_be_minified?(asset, options)
        ::Uglifier.compile(rendered_asset)
      else
        rendered_asset
      end
    end

    # Return true if the given asset should be minified with Uglifier.
    def should_be_minified?(asset, options)
      asset.to_s.end_with?('.js') && options[:minify]
    end

    def render_asset_renderer
      @render_asset_renderer ||= self.class.const_get('RenderingController').new
    end

    # Render any script tags defined by the :script_tags options that we have
    # a public URL for.
    def render_asset_script_tags(options, public_urls)
      # Fetch the current set of script tags for the store.
      current_script_tags = shop.with_api_context { ShopifyAPI::ScriptTag.find(:all) }

      # Iterate each script tag for which we have a known public URL and create
      # or update the corresponding script tag resource.
      public_urls.slice(*options[:script_tags]).each do |asset, public_url|
        script_tag = current_script_tags.find(-> { ShopifyAPI::ScriptTag.new(event: 'onload') }) { |script_tag| script_tag.src.include?("#{asset}?") }
        script_tag.src = public_url
        shop.with_api_context { script_tag.save }
      end
    end

end
