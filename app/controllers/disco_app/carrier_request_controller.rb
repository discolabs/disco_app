module DiscoApp
  module CarrierRequestController
    extend ActiveSupport::Concern

    included do
      before_action :verify_carrier_request_signature
    end
    
    private

      def verify_carrier_request_signature
        unless carrier_request_signature_is_valid?
          head :unauthorized
        end
      end

      def carrier_request_signature_is_valid?
        return true unless Rails.env.production?
        data = request.body.read.to_s
        hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
        digest  = OpenSSL::Digest::Digest.new('sha256')
        calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ShopifyApp.configuration.secret, data)).strip
        request.body.rewind
        calculated_hmac == hmac_header
      end

      def carrier_request_domain
        request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']
      end

  end
end
