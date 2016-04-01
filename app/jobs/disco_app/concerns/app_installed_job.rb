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
  # - Subscribe to default plan, if any exists.
  #
  def perform(shopify_domain)
    DiscoApp::SynchroniseWebhooksJob.perform_now(shopify_domain)
    DiscoApp::SynchroniseCarrierServiceJob.perform_now(shopify_domain)
    DiscoApp::ShopUpdateJob.perform_now(shopify_domain)

    @shop.reload

    if default_plan.present?
      DiscoApp::SubscriptionService.subscribe(@shop, default_plan)
    end
  end

  # Provide an overridable hook for applications to examine the @shop object
  # and return the default plan, if any, the shop should be subscribed to. If
  # nil is returned, no automatic subscription will take place and the store
  # owner will be forced to choose a plan after installation.
  #
  # If implementing this method, it should be memoized.
  def default_plan
    nil
  end

end
