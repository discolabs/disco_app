module DiscoApp::Concerns::AppUninstalledJob
  extend ActiveSupport::Concern

  included do
    before_enqueue { @shop.awaiting_uninstall! }
    before_perform { @shop.uninstalling! }
    after_perform { @shop.uninstalled! }
  end

  # Perform application uninstallation.
  #
  # - Mark any recurring application charges as cancelled.
  # - Remove any stored sessions for the shop.
  #
  def perform(shop, shop_data)
    DiscoApp::ChargesService.cancel_recurring_charges(@shop)
    DiscoApp::SendSubscriptionJob.perform_later(@shop)
    @shop.sessions.delete_all
  end

end
