class AppUninstalledJob < DiscoApp::ShopJob

  def perform(domain, shop_data)
    # Check the application isn't already uninstalled or is uninstalling for this store.
    return if @shop.uninstalling? or @shop.uninstalled?

    # Mark as beginning uninstallation.
    @shop.uninstalling!

    # Add teardown here.

    # Mark as uninstalled.
    @shop.uninstalled!
  end

end
