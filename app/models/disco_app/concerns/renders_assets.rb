require 'render_anywhere'

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
    #                     uploaded to Shopify.
    #
    #   triggered_by:     Optional. A list of attributes that should trigger the
    #                     re-rendering and upload of the assets defined by the
    #                     `assets` option, provided as a list of string. If
    #                     empty or nil, nothing will be triggered.
    #
    #   compress:         Optional. Whether Javascript and SCSS assets should be
    #                     compressed after being rendered. Defaults to true in
    #                     production environments, false otherwise.
    #
    def renders_assets(*asset_groups)
      options = asset_groups.last.is_a?(Hash) ? asset_groups.pop : {}
      options = renders_assets_default_options.merge(options)

      # Ensure the assets and triggered by options are arrays.
      options[:assets] = options[:assets] ? Array(options[:assets]).map(&:to_sym) : []
      options[:triggered_by] = options[:triggered_by] ? Array(options[:triggered_by]).map(&:to_s) : []

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
        compress: Rails.env.production?
      }
    end

  end

  # Callback, triggered after a model save. Iterates through each asset group
  # defined on the model and queues a render job if any of the changed
  # attributes are found in the asset group's triggered_by list.
  def queue_render_asset_group_job
    renderable_asset_groups.each do |asset_group, options|
      unless (previous_changes.keys & options[:triggered_by]).empty?
        DiscoApp::RenderAssetGroupJob.perform_later(shop, self, asset_group.to_s)
      end
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
    options[:assets].each do |asset|
      shopify_asset = shop.temp {
        ShopifyAPI::Asset.create(
          key: "assets/#{asset}",
          value: render_asset_group_asset(asset, options)
        )
      }
    end
  end

  private

    def render_asset_group_asset(asset, options)
      render_asset_renderer.render_to_string(
        template: "assets/#{asset}",
        layout: nil,
        locals: {
          :"@#{self.class.name.underscore}" => self
        }
      )
    end

    def render_asset_renderer
      @render_asset_renderer ||= self.class.const_get('RenderingController').new
    end

end
