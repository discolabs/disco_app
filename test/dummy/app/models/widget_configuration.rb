class WidgetConfiguration < ActiveRecord::Base
  include DiscoApp::Concerns::RendersAssets

  belongs_to :shop, class_name: 'DiscoApp::Shop'

  renders_assets :widget_assets, assets: ['test.css', 'test.js'], triggered_by: ['locale', 'background_color']
  renders_assets :liquid_assets, assets: 'test.liquid', triggered_by: ['locale']

end
