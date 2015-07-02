module DiscoApp
  module AppProxyController
    extend ActiveSupport::Concern

    included do
      before_action :verify_proxy_signature
    end

    private

      def verify_proxy_signature
        unless proxy_signature_is_valid?
          head :unauthorized
        end
      end

      def proxy_signature_is_valid?
        return true unless Rails.env.production?
        query_hash = Rack::Utils.parse_query(request.query_string)
        signature = query_hash.delete("signature")
        sorted_params = query_hash.collect{ |k, v| "#{k}=#{Array(v).join(',')}" }.sort.join
        calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), ShopifyApp.configuration.secret, sorted_params)
        signature == calculated_signature
      end

  end
end
