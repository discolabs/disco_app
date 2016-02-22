module DiscoApp::Concerns::SynchronisesWithShopify
  extend ActiveSupport::Concern

  class_methods do

    def synchronise_from_shopify(shop, data)
      data = data.with_indifferent_access

      instance = self.find_or_create_by!(id: data[:id]) do |instance|
        instance.shop = shop
        instance.data = data
      end

      instance.update(data: data)

      instance
    end

    def synchronise_deletion_from_shopify(shop, data)
      data = data.with_indifferent_access
      self.destroy_all(shop: shop, id: data[:id])
    end

  end

end
