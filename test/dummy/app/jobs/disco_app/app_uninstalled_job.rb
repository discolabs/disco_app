class DiscoApp::AppUninstalledJob < DiscoApp::ShopJob
  include DiscoApp::Concerns::AppUninstalledJob

  # Extend the perform method to change the country name of the shop to
  # 'Nowhere' on uninstallation.
  def perform(domain, shop_data)
    super(domain, shop_data)
    @shop.update(country_name: 'Nowhere')
  end

end
