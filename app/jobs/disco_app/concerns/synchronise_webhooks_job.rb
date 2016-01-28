module DiscoApp::Concerns::SynchroniseWebhooksJob
  extend ActiveSupport::Concern

  # Ensure the webhooks registered with our shop are the same as those listed
  # in our application configuration.
  def perform(shopify_domain)
    # Get the full list of expected webhook topics.
    expected_topics = [:'app/uninstalled', :'shop/update'] + topics

    # Registered any webhooks that haven't been registered yet.
    (expected_topics - current_topics).each do |topic|
      ShopifyAPI::Webhook.create(
        topic: topic,
        address: webhooks_url,
        format: 'json'
      )
    end

    # Remove any extraneous topics.
    current_webhooks.each do |webhook|
      unless expected_topics.include?(webhook.topic.to_sym)
        webhook.delete
      end
    end

    # Ensure webhook addresses are current.
    current_webhooks.each do |webhook|
      unless webhook.address == webhooks_url
        webhook.address = webhooks_url
        webhook.save
      end
    end
  end

  protected

    # Return a list of additional webhook topics to listen for. This method
    # can be overridden in the application to provide a list of app-specific
    # webhooks that should be created during synchronisation.
    def topics
      []
    end

  private

    # Return a list of currently registered topics.
    def current_topics
      current_webhooks.map(&:topic).map(&:to_sym)
    end

    # Return a list of current registered webhooks.
    def current_webhooks
      @current_webhooks ||= ShopifyAPI::Webhook.find(:all)
    end

    # Return the absolute URL to the webhooks endpoint.
    def webhooks_url
      DiscoApp::Engine.routes.url_helpers.webhooks_url
    end

end
