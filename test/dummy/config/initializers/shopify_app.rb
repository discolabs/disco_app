ShopifyApp.configure do |config|
  config.api_key = ENV['SHOPIFY_APP_API_KEY']
  config.secret = ENV['SHOPIFY_APP_SECRET']
  config.redirect_uri = ENV['SHOPIFY_APP_REDIRECT_URI']
  config.scope = ENV['SHOPIFY_APP_SCOPE']
  config.embedded_app = true
end
