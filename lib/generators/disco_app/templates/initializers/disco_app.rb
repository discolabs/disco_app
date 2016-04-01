DiscoApp::Engine.routes.default_url_options[:host] = ENV['DEFAULT_HOST']

DiscoApp.configure do |config|
  # Required configuration.
  config.app_name = ENV['SHOPIFY_APP_NAME']

  # Set the below if using an application proxy.
  config.app_proxy_prefix = ENV['SHOPIFY_APP_PROXY_PREFIX']

  # Set the below to create real Shopify charges.
  config.real_charges = ENV['SHOPIFY_REAL_CHARGES'] === 'true'

  # Optional configuration. These flags are only respected in the development
  # environment and will have no effect in production.
  config.skip_proxy_verification = ENV['SKIP_PROXY_VERIFICATION'] == 'true'
  config.skip_webhook_verification = ENV['SKIP_WEBHOOK_VERIFICATION'] == 'true'
  config.skip_carrier_request_verification = ENV['SKIP_CARRIER_REQUEST_VERIFICATION'] == 'true'
  config.skip_oauth = ENV['SKIP_OAUTH'] == 'true'
end
