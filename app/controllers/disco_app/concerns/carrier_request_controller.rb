module DiscoApp::Concerns::CarrierRequestController
  extend ActiveSupport::Concern

  included do
    before_action :verify_carrier_request
  end

  private

    def verify_carrier_request
      unless carrier_request_signature_is_valid?
        head :unauthorized
      end
    end

    def carrier_request_signature_is_valid?
      return true if DiscoApp.configuration.skip_carrier_request_verification?
      DiscoApp::CarrierRequestService.is_valid_hmac?(request.body.read.to_s, ShopifyApp.configuration.secret, request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'])
    end

end
