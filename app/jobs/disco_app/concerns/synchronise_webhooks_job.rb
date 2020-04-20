module DiscoApp::Concerns::SynchroniseWebhooksJob

  extend ActiveSupport::Concern

  COMMON_WEBHOOKS = %i[app/uninstalled shop/update]

  # Ensure the webhooks registered with our shop are the same as those listed
  # in our application configuration.
  def perform(_shop)
    # Register any webhooks that haven't been registered yet.
    (expected_topics - current_topics).each do |topic|
      with_verbose_output(topic) do
        ShopifyAPI::Webhook.create(
          topic: topic,
          fields: topic_fields(topic),
          address: webhooks_url,
          format: 'json'
        )
      end
    end

    # Remove any extraneous topics.
    current_webhooks.each do |webhook|
      ShopifyAPI::Webhook.delete(webhook.id) unless expected_topics.include?(webhook.topic.to_sym)
    end

    # Ensure webhook addresses are current.
    current_webhooks.each do |webhook|
      expected_fields = topic_fields(webhook.topic.to_sym).map(&:to_s)

      next if webhook.address == webhooks_url && webhook.fields == expected_fields

      webhook.address = webhooks_url
      webhook.fields = expected_fields
      webhook.save
    end
  end

  private

    # Get the full list of expected webhook topics.
    def expected_topics
      @expected_topics ||= (COMMON_WEBHOOKS + (DiscoApp.configuration.webhook_topics || [])).map(&:to_sym)
    end

    # Return a list of currently registered topics.
    def current_topics
      @current_topics ||= current_webhooks.map(&:topic).map(&:to_sym)
    end

    # Return a list of current registered webhooks.
    def current_webhooks
      @current_webhooks ||= ShopifyAPI::Webhook.find(:all)
    end

    # Return a list of requested fields for the given topic.
    def topic_fields(topic)
      webhook_fields[topic] || []
    end

    # Return a list of topic-to-field mappings.
    def webhook_fields
      @webhook_fields ||= (DiscoApp.configuration.webhook_fields || {}).symbolize_keys
    end

    # Return the absolute URL to the webhooks endpoint.
    def webhooks_url
      DiscoApp::Engine.routes.url_helpers.webhooks_url
    end

    def with_verbose_output(topic)
      print "\n#{topic}"
      shopify_response = yield
      if shopify_response.errors.blank?
        print " - registered successfully\n"
      else
        print " - not registered\n"
        puts shopify_response.errors.messages
      end
    end

end
