class ShopUpdatedJob < DiscoApp::ShopJob

  def perform(domain, shop_data = nil)
    # If we weren't provided with shop data (eg from a webhook), fetch it.
    shop_data ||= ActiveSupport::JSON::decode(ShopifyAPI::Shop.current.to_json)

    # Ensure we can access shop data through symbols.
    shop_data = HashWithIndifferentAccess.new(shop_data)

    # Update model attributes from data.
    # @TODO
    @shop.update_attributes({})
  end

end
