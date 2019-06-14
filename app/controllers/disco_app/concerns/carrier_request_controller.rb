module DiscoApp::Concerns::CarrierRequestController

  extend ActiveSupport::Concern

  included do
    before_action :verify_carrier_request
    before_action :find_shop
    before_action :validate_rate_params
  end

  private

    def verify_carrier_request
      head :unauthorized unless carrier_request_signature_is_valid?
    end

    def carrier_request_signature_is_valid?
      return true if Rails.env.development? && DiscoApp.configuration.skip_carrier_request_verification?

      DiscoApp::CarrierRequestService.is_valid_hmac?(request.body.read.to_s, ShopifyApp.configuration.secret, request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'])
    end

    def find_shop
      head :unauthorized unless (@shop = DiscoApp::Shop.find_by_shopify_domain(request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']))
    end

    def validate_rate_params
      head :bad_request unless params[:rate].present? && params[:rate][:origin].present? && params[:rate][:destination].present? && params[:rate][:items].present?
    end

end
