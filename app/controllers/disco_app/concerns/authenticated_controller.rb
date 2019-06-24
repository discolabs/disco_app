module DiscoApp::Concerns::AuthenticatedController

  extend ActiveSupport::Concern
  include ShopifyApp::LoginProtection

  included do
    before_action :auto_login
    before_action :check_shop_whitelist
    before_action :login_again_if_different_shop
    before_action :shopify_shop
    before_action :check_installed
    before_action :check_current_subscription
    before_action :check_active_charge
    around_action :shopify_session
    layout 'embedded_app'
  end

  private

    def auto_login
      return unless shop_session.nil? && request_hmac_valid?

      shop = DiscoApp::Shop.find_by_shopify_domain(sanitized_shop_name)
      return unless shop.present?

      session[:shopify] = shop.id
      session[:shopify_domain] = sanitized_shop_name
    end

    def shopify_shop
      if shop_session
        @shop = DiscoApp::Shop.find_by!(shopify_domain: @shop_session.url)
      else
        redirect_to_login
      end
    end

    def check_installed
      if @shop.awaiting_install? || @shop.installing?
        redirect_if_not_current_path disco_app.installing_path
        return
      end
      if @shop.awaiting_uninstall? || @shop.uninstalling?
        redirect_if_not_current_path disco_app.uninstalling_path
        return
      end
      redirect_if_not_current_path disco_app.install_path unless @shop.installed?
    end

    def check_current_subscription
      redirect_if_not_current_path disco_app.new_subscription_path unless @shop.current_subscription?
    end

    def check_active_charge
      return unless @shop.current_subscription?
      return unless @shop.current_subscription.requires_active_charge?
      return if @shop.development?
      return if @shop.current_subscription.active_charge?

      redirect_if_not_current_path disco_app.new_subscription_charge_path(@shop.current_subscription)
    end

    def redirect_if_not_current_path(target)
      redirect_to target if request.path != target
    end

    def request_hmac_valid?
      DiscoApp::RequestValidationService.hmac_valid?(request.query_string, ShopifyApp.configuration.secret)
    end

    def check_shop_whitelist
      return unless shop_session
      return unless ENV['WHITELISTED_DOMAINS'].present?
      return if ENV['WHITELISTED_DOMAINS'].include?(shop_session.url)

      redirect_to_login
    end

end
