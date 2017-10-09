require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)
require "disco_app"

module Dummy
  class Application < Rails::Application
    config.action_dispatch.default_headers['P3P'] = 'CP="Not used"'
    config.action_dispatch.default_headers.delete('X-Frame-Options')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Set the default host for absolute URL routing purposes
    routes.default_url_options[:host] = ENV['DEFAULT_HOST']

    # Configure custom session storage
    ActionDispatch::Session::ActiveRecordStore.session_class = DiscoApp::Session
    ActiveRecord::SessionStore::Session.table_name = 'disco_app_sessions'

    # Explicitly prevent real charges being created by default
    config.x.shopify_charges_real = false
  end
end

