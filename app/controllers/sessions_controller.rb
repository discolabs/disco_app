class SessionsController < ApplicationController
  include ShopifyApp::SessionsController

  protected

    # Override the authenticate method to allow skipping OAuth in development
    # mode. Skipping OAuth still requires a shop with Shopify domain specified
    # by the `shop` parameter to be present in the local database.
    def authenticate
      if Rails.env.development? and DiscoApp.configuration.skip_oauth?
        shop = DiscoApp::Shop.find_by_shopify_domain!(sanitized_shop_name)

        sess = ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
        session[:shopify] = ShopifyApp::SessionRepository.store(sess)
        session[:shopify_domain] = sanitized_shop_name

        redirect_to disco_app.frame_path and return
      end
      super
    end

end