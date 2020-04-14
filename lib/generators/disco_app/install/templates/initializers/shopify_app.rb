ShopifyApp.configure do |config|
  config.application_name = ENV['SHOPIFY_APP_NAME']
  config.api_key = ENV['SHOPIFY_APP_API_KEY']
  config.secret = ENV['SHOPIFY_APP_SECRET']
  config.old_secret = ''
  config.scope = ENV['SHOPIFY_APP_SCOPE']
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = ENV.fetch('SHOPIFY_APP_API_VERSION', '2019-10')
  config.session_repository = ShopifyApp::InMemorySessionStore
end
