module DiscoApp::Concerns::WebhooksController
  extend ActiveSupport::Concern

  included do
    before_action :verify_webhook
    protect_from_forgery with: :null_session
  end

  def process_webhook
    # Get the topic and domain for this webhook.
    topic = request.headers['HTTP_X_SHOPIFY_TOPIC']
    shopify_domain = request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']

    # Ensure a domain was provided in the headers.
    unless shopify_domain
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
    job_class.perform_later(shopify_domain, data)

    render body: nil
  end

  private

    def verify_webhook
      unless webhook_is_valid?
        head :unauthorized
      end
      request.body.rewind
    end

    def webhook_is_valid?
      return true if Rails.env.development? and DiscoApp.configuration.skip_webhook_verification?
      DiscoApp::WebhookService.is_valid_hmac?(request.body.read.to_s, ShopifyApp.configuration.secret, request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'])
    end

end
