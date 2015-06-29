module DiscoApp
  module AuthenticatedController
    extend ActiveSupport::Concern

    included do
      before_action :login_again_if_different_shop
      before_action :shopify_shop
      before_action :verify_status
      around_filter :shopify_session
      layout 'embedded_app'
    end

    private

      def shopify_shop
        if shop_session
          @shop = ::Shop.find_by!(shopify_domain: @shop_session.url)
        else
          redirect_to_login
        end
      end

      def verify_status
        if @shop.charge_none? or @shop.charge_declined? or @shop.charge_cancelled?
          redirect_if_not_current_path(disco_app.new_charge_path)
        elsif @shop.charge_pending?
          redirect_if_not_current_path(disco_app.accept_charge_path)
        elsif @shop.charge_accepted?
          redirect_if_not_current_path(disco_app.activate_charge_path)
        elsif @shop.never_installed? or @shop.uninstalled?
          redirect_if_not_current_path(disco_app.install_path)
        elsif @shop.installing?
          redirect_if_not_current_path(disco_app.installing_path)
        elsif @shop.uninstalling?
          redirect_if_not_current_path(disco_app.uninstalling_path)
        end
      end

      def redirect_if_not_current_path(target)
        if request.path != target
          redirect_to target
        end
      end

  end
end