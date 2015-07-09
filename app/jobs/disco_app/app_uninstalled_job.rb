module DiscoApp
  class AppUninstalledJob < DiscoApp::ShopJob

    before_enqueue { @shop.awaiting_uninstall! }
    before_perform { @shop.uninstalling! }
    after_perform { @shop.uninstalled! }

    def perform(domain, shop_data)

      # Mark the shop's charge status as "cancelled" unless charges have been waived.
      unless @shop.charge_waived?
        @shop.charge_cancelled!
      end

    end

  end
end
