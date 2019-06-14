module DiscoApp::Concerns::ShopUpdateJob

  extend ActiveSupport::Concern

  # Perform an update of the current shop's information.
  def perform(_shop, shop_data = nil)
    # If we weren't provided with shop data (eg from a webhook), fetch it.
    shop_data ||= ActiveSupport::JSON.decode(ShopifyAPI::Shop.current.to_json)

    # Update attributes stored directly on the Shop model, along with the data hash itself.
    @shop.update(shop_data.with_indifferent_access.slice(*DiscoApp::Shop.column_names).except(:id, :created_at).merge(data: shop_data))
  end

end
