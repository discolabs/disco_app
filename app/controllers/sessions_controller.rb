class SessionsController < ActionController::Base
  include ShopifyApp::SessionsConcern

  def referral
    cookies[DiscoApp::SOURCE_COOKIE_KEY] = params[:source] if params[:source].present?
    cookies[DiscoApp::CODE_COOKIE_KEY] = params[:code] if params[:code].present?
    redirect_to root_path
  end

  def failure
    flash[:notice] = 'There was an issue while trying to authenticate, please retry'
    redirect_to root_path
  end

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
