class DiscoApp::AppUninstalledJob < DiscoApp::ShopJob
  include DiscoApp::Concerns::AppUninstalledJob

  # Extend the perform method to change the country name of the shop to
  # 'Nowhere' on uninstallation.
  def perform(_shop, shop_data)
    super
    @shop.update(data: @shop.data.merge(country_name: 'Nowhere'))
  end

end
