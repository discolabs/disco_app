require 'shopify_app'
require 'bootstrap-sass'
require 'jquery-rails'
require 'turbolinks'

module DiscoApp
  class Engine < ::Rails::Engine

    isolate_namespace DiscoApp
    engine_name 'disco_app'

    # Ensure our frame assets are included for precompilation.
    initializer 'disco_app.assets.precompile' do |app|
      app.config.assets.precompile += %w(disco_app/frame.css disco_app/frame.js)
    end

  end
end
