module OmniAuth::Strategies
  class ShopifyUser < Shopify

    def name
      :shopify_user
    end

  end
end

SETUP_PROC = lambda do |env|
  env['omniauth.strategy'].options[:per_user_permissions] = true
  params = Rack::Utils.parse_query(env['QUERY_STRING'])
  env['omniauth.strategy'].options[:client_options][:site] = "https://#{params['shop']}"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shopify,
           ShopifyApp.configuration.api_key,
           ShopifyApp.configuration.secret,
           scope: ShopifyApp.configuration.scope
  provider :shopify_user,
           ShopifyApp.configuration.api_key,
           ShopifyApp.configuration.secret,
           scope: ShopifyApp.configuration.scope,
           setup: SETUP_PROC
end
