module DiscoApp
  class AppInstalledJob < DiscoApp::ShopJob

    before_enqueue { @shop.awaiting_install! }
    before_perform { @shop.installing! }
    after_perform { @shop.installed! }

    def perform(domain)

      # Install webhooks.
      (base_webhook_topics + webhook_topics).each do |topic|
        ShopifyAPI::Webhook.create(topic: topic, address: webhooks_url, format: 'json')
      end

      # Perform initial update of shop information.
      ::ShopUpdateJob.perform_now(domain)

    end

    protected

      # Return a list of additional webhook topics to listen for.
      # This method should be overridden in the application.
      def webhook_topics
        []
      end

    private

      # Return a list of webhook topics that will always be set up for the application.
      def base_webhook_topics
        [:'app/uninstalled', :'shop/update']
      end

      # Return the absolute URL to the webhooks endpoint.
      def webhooks_url
        DiscoApp::Engine.routes.url_helpers.webhooks_url
      end

  end
end
