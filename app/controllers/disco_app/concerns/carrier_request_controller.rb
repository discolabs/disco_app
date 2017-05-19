module DiscoApp::Concerns::CarrierRequestController
  extend ActiveSupport::Concern

  included do
    before_action :verify_carrier_request
    before_action :find_shop
    before_action :validate_rate_params
  end

  private

    def verify_carrier_request
      unless carrier_request_signature_is_valid?
        head :unauthorized
      end
    end

    def carrier_request_signature_is_valid?
      return true if (Rails.env.development? or Rails.env.test?) and DiscoApp.configuration.skip_carrier_request_verification?
      DiscoApp::CarrierRequestService.is_valid_hmac?(request.body.read.to_s, ShopifyApp.configuration.secret, request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'])
    end

    def find_shop
      unless (@shop = DiscoApp::Shop.find_by_shopify_domain(request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']))
        head :unauthorized
      end
    end

    def validate_rate_params
      unless params[:rate].present? and params[:rate][:origin].present? and params[:rate][:destination].present? and params[:rate][:items].present?
        head :bad_request
      end
    end

end
