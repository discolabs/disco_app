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

      DiscoApp::CarrierRequestService.valid_hmac?(
        request.body.read.to_s,
        ShopifyApp.configuration.secret,
        request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
      )
    end

    def find_shop
      @shop = DiscoApp::Shop.find_by(shopify_domain: request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'])

      head :unauthorized unless @shop
    end

    def validate_rate_params
      head :bad_request unless request_is_valid?
    end

    def request_is_valid?
      return false if params[:rate].blank?
      return false if params[:rate][:origin].blank?
      return false if params[:rate][:destination].blank?
      return false if params[:rate][:items].blank?
    end

end
