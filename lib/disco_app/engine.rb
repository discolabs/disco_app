require 'shopify_app'
require 'jquery-rails'
require 'turbolinks'
require 'activerecord/session_store'
require 'disco_app/session'
require 'jsonapi-resources'
require 'react-rails'

module DiscoApp
  class Engine < ::Rails::Engine

    isolate_namespace DiscoApp
    engine_name 'disco_app'

    # Ensure DiscoApp helpers are available throughout application.
    config.to_prepare do
      ApplicationController.helper(DiscoApp::ApplicationHelper)
    end

    # Ensure our frame assets are included for precompilation.
    initializer 'disco_app.assets.precompile' do |app|
      app.config.assets.precompile += %w(disco_app/icon.svg disco_app/admin.css disco_app/frame.css disco_app/frame.js)
    end

  end
end
