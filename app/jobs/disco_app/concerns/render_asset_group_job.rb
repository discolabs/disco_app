module DiscoApp::Concerns::RenderAssetGroupJob
  extend ActiveSupport::Concern

  def perform(shop, instance, asset_group)
    instance.render_asset_group(asset_group.to_sym)
  end

end
