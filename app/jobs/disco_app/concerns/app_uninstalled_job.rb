module DiscoApp::Concerns::AppUninstalledJob
  extend ActiveSupport::Concern

  included do
    before_enqueue { @shop.awaiting_uninstall! }
    before_perform { @shop.uninstalling! }
    after_perform { @shop.uninstalled! }
  end

  # Perform application uninstallation.
  #
  # - Mark charge status as "cancelled" unless charges have been waived.
  # - Remove any stored sessions for the shop.
  #
  def perform(domain, shop_data)
    @shop.sessions.delete_all
  end

end
