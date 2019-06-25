class JsConfiguration < ApplicationRecord

  include DiscoApp::Concerns::RendersAssets

  belongs_to :shop, class_name: 'DiscoApp::Shop'

  renders_assets :js_assets, assets: 'assets/test.js', triggered_by: 'locale'

end
