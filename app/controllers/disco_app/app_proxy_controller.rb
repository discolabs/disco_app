module DiscoApp
  module AppProxyController
    extend ActiveSupport::Concern

    included do
      before_action :verify_proxy_signature
      after_action :add_liquid_header

      rescue_from ActiveRecord::RecordNotFound do |exception|
        render_error 404
      end
    end

    private

      def verify_proxy_signature
        unless proxy_signature_is_valid?
          head :unauthorized
        end
      end

      def proxy_signature_is_valid?
        return true if DiscoApp.configuration.skip_proxy_verification?
        query_hash = Rack::Utils.parse_query(request.query_string)
        signature = query_hash.delete("signature")
        sorted_params = query_hash.collect{ |k, v| "#{k}=#{Array(v).join(',')}" }.sort.join
        calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ShopifyApp.configuration.secret, sorted_params)
        signature == calculated_signature
      end

      def add_liquid_header
        response.headers['Content-Type'] = 'application/liquid'
      end

      def render_error(status)
        add_liquid_header
        render "disco_app/proxy_errors/#{status}", status: status
      end

  end
end
