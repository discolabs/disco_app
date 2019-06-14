DiscoApp::Engine.routes.default_url_options[:host] = ENV['DEFAULT_HOST']

DiscoApp.configure do |config|
  # Required configuration.
  config.app_name = ENV['SHOPIFY_APP_NAME']

  # Set a list of webhook topics to listen for.
  # See https://help.shopify.com/api/reference/webhook.
  config.webhook_topics = %i[orders/create orders/paid carts/create carts/update]

  # Set the below if using an application proxy.
  config.app_proxy_prefix = ENV['SHOPIFY_APP_PROXY_PREFIX']

  # Set the below if providing a carrier service endpoint.
  # Note that if using a URL helper to set the endpoint, we use a lambda
  # function to ensure that the URL helper is only evaluated when we need it.
  config.carrier_service_callback_url = -> { Rails.application.routes.url_helpers.carrier_service_callback_url }

  # Set the below to create real charges.
  config.real_charges = ENV['SHOPIFY_REAL_CHARGES'] === 'true'

  # Optional configuration. These flags are only respected in the development
  # environment and will have no effect in production.
  config.skip_proxy_verification = ENV['SKIP_PROXY_VERIFICATION'] == 'true'
  config.skip_webhook_verification = ENV['SKIP_WEBHOOK_VERIFICATION'] == 'true'
  config.skip_carrier_request_verification = ENV['SKIP_CARRIER_REQUEST_VERIFICATION'] == 'true'
  config.skip_oauth = ENV['SKIP_OAUTH'] == 'true'
end
