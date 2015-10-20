module DiscoApp::Concerns::AppInstalledJob
  extend ActiveSupport::Concern

  included do
    before_enqueue { @shop.awaiting_install! }
    before_perform { @shop.installing! }
    after_perform { @shop.installed! }
  end

  # Perform application installation.
  #
  # - Install webhooks, using a list generated from the base_webhook_topics and
  #   webhook_topics methods.
  # - Perform initial update of shop information.
  #
  def perform(domain)
    (base_webhook_topics + webhook_topics).each do |topic|
      ShopifyAPI::Webhook.create(topic: topic, address: webhooks_url, format: 'json')
    end

    DiscoApp::ShopUpdateJob.perform_now(domain)
  end

  protected

    # Return a list of additional webhook topics to listen for. This method
    # can be overridden in the application to provide a list of app-specific
    # webhooks that should be created during installation.
    def webhook_topics
      []
    end

  private

    # Return a list of webhook topics that will always be set up for the
  # # application.
    def base_webhook_topics
      [:'app/uninstalled', :'shop/update']
    end

    # Return the absolute URL to the webhooks endpoint.
    def webhooks_url
      DiscoApp::Engine.routes.url_helpers.webhooks_url
    end

end
