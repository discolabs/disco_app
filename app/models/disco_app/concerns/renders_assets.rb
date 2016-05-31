module DiscoApp::Concerns::RendersAssets
  extend ActiveSupport::Concern

  included do
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
    #   assets:           Required. A list of asset to be rendered.
    #
    #   triggered_by:     Optional. A list of attributes that should trigger the
    #                     re-rendering and upload of the assets defined by the
    #                     `assets` option, provided as a list of string. If
    #                     empty or nil, nothing will be triggered.
    #
    def renders_assets(*asset_groups)
      options = asset_groups.last.is_a?(Hash) ? asset_groups.pop : {}

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

  end

  # Triggered callback.
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

  # Render the specified asset group.
  def render_asset_group(asset_group)
    puts "Render: #{asset_group}"
  end

end
