ShopifyApp.configure do |config|
  config.api_key = ENV['SHOPIFY_APP_API_KEY']
  config.secret = ENV['SHOPIFY_APP_SECRET']
  config.scope = ENV['SHOPIFY_APP_SCOPE']
  config.embedded_app = true
  config.api_version = ENV.fetch('SHOPIFY_APP_API_VERSION', '2019-10')
end
