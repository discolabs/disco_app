class DiscoApp::SendSubscriptionJob < DiscoApp::ShopJob

  def perform(shop)
    @shop.disco_api_client.create_app_subscription unless ENV['DISCO_API_URL'].empty?
  end

end
