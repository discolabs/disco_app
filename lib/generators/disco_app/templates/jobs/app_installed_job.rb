class AppInstalledJob < DiscoApp::ShopJob

  def perform(domain)
    # Check that the application isn't already installed or installing for this store.
    return if @shop.installing? or @shop.installed?

    # Mark as installing.
    @shop.installing!

    # Install webhooks.
    webhooks_url = DiscoApp::Engine.routes.url_helpers.webhooks_url
    ShopifyAPI::Webhook.create(topic: 'app/uninstalled', address: webhooks_url, format: 'json')
    ShopifyAPI::Webhook.create(topic: 'shop/update', address: webhooks_url, format: 'json')

    # Perform initial update of shop information.
    ::ShopUpdateJob.perform_now(domain)

    # Mark store as installed.
    @shop.installed!
  end

end
