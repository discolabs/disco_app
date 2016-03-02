module DiscoApp::Concerns::AppInstalledJob
  extend ActiveSupport::Concern

  included do
    before_enqueue { @shop.awaiting_install! }
    before_perform { @shop.installing! }
    after_perform { @shop.installed! }
  end

  # Perform application installation.
  #
  # - Synchronise webhooks.
  # - Synchronise carrier service, if required.
  # - Perform initial update of shop information.
  #
  def perform(shopify_domain)
    DiscoApp::SynchroniseWebhooksJob.perform_now(shopify_domain)
    DiscoApp::SynchroniseCarrierServiceJob.perform_now(shopify_domain)
    DiscoApp::ShopUpdateJob.perform_now(shopify_domain)
    @shop.reload
  end

end
