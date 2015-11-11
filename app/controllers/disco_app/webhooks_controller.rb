module DiscoApp
  class WebhooksController < ActionController::Base

    before_action :verify_webhook

    def process_webhook
      # Get the topic and domain for this webhook.
      topic = request.headers['HTTP_X_SHOPIFY_TOPIC']
      domain = request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']

      # Ensure a domain was provided in the headers.
      unless domain
        head :bad_request
      end

      # Try to find a matching background job task for the given topic using class name.
      job_class = DiscoApp::WebhookService.find_job_class(topic)

      # Return bad request if we couldn't match a job class.
      unless job_class.present?
        head :bad_request
      end

      # Decode the body data and enqueue the appropriate job.
      data = ActiveSupport::JSON::decode(request.body.read).with_indifferent_access
      job_class.perform_later(domain, data)

      render nothing: true
    end

    private

      # Verify a webhook request.
      def verify_webhook
        unless DiscoApp::WebhookService.is_valid_hmac?(request.body.read.to_s, ShopifyApp.configuration.secret, request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'])
          head :unauthorized
        end
        request.body.rewind
      end

  end
end
