class WidgetConfiguration < ApplicationRecord

  include DiscoApp::Concerns::RendersAssets

  belongs_to :shop, class_name: 'DiscoApp::Shop'

  renders_assets :widget_assets, assets: ['assets/widget.scss', 'assets/widget.js'], triggered_by: ['locale', 'background_color']
  renders_assets :liquid_assets, assets: 'snippets/widget.liquid', triggered_by: ['locale']
  renders_assets :script_tag_assets, assets: 'assets/script_tag.js', script_tags: 'assets/script_tag.js'

end
