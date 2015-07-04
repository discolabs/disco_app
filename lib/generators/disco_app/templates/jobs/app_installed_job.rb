class AppInstalledJob < DiscoApp::ShopJob

  before_enqueue { @shop.awaiting_install! }
  before_perform { @shop.installing! }
  after_perform { @shop.installed! }

  def perform(domain)

    # Install webhooks.
    webhooks_url = DiscoApp::Engine.routes.url_helpers.webhooks_url
    ShopifyAPI::Webhook.create(topic: 'app/uninstalled', address: webhooks_url, format: 'json')
    ShopifyAPI::Webhook.create(topic: 'shop/update', address: webhooks_url, format: 'json')

    # Perform initial update of shop information.
    ::ShopUpdateJob.perform_now(domain)

  end

end
