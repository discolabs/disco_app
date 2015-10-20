module DiscoApp::Concerns::ShopUpdateJob
  extend ActiveSupport::Concern

  # Perform an update of the current shop's information.
  def perform(shopify_domain, shop_data = nil)
    # If we weren't provided with shop data (eg from a webhook), fetch it.
    shop_data ||= ActiveSupport::JSON::decode(ShopifyAPI::Shop.current.to_json)

    # Ensure we can access shop data through symbols.
    shop_data = HashWithIndifferentAccess.new(shop_data)

    # Update model attributes present in both our model and the data hash.
    @shop.update_attributes(shop_data.except(:id, :created_at).slice(*DiscoApp::Shop.column_names))
  end

end
