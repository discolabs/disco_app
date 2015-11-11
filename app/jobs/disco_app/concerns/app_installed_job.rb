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
  # - Perform initial update of shop information.
  #
  def perform(domain)
    DiscoApp::SynchroniseWebhooksJob.perform_now(domain)
    DiscoApp::ShopUpdateJob.perform_now(domain)
  end

end
