module DiscoApp
  class WebhooksController < ActionController::Base

    before_action :verify_webhook

    def process_webhook
      # Get the topic and domain for this webhook.
      topic = request.headers['HTTP_X_SHOPIFY_TOPIC']
      domain = request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']

      # Try to find a matching background job task for the given topic using class name.
      begin
        job_class = "#{topic}_job".gsub('/', '_').classify.constantize
      rescue NameError
        head :bad_request
      end

      # Decode the body data and enqueue the appropriate job.
      data = ActiveSupport::JSON::decode(request.body.read)
      job_class.perform_later(domain, data)

      render nothing: true
    end

    private

      # Verify a webhook request.
      def verify_webhook
        data = request.body.read.to_s
        hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
        digest  = OpenSSL::Digest::Digest.new('sha256')
        calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ShopifyApp.configuration.secret, data)).strip
        unless calculated_hmac == hmac_header
          head :unauthorized
        end
        request.body.rewind
      end

  end
end