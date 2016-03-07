module DiscoApp::Concerns::Synchronises
  extend ActiveSupport::Concern

  class_methods do

    def should_synchronise?(shop, data)
      true
    end

    def synchronise(shop, data)
      data = data.with_indifferent_access

      return unless should_synchronise?(shop, data)

      instance = self.find_or_create_by!(id: data[:id]) do |instance|
        instance.shop = shop
        instance.data = data
      end

      instance.update(data: data)

      instance
    end

    def should_synchronise_deletion?(shop, data)
      true
    end

    def synchronise_deletion(shop, data)
      data = data.with_indifferent_access

      return unless should_synchronise_deletion?(shop, data)

      self.destroy_all(shop: shop, id: data[:id])
    end

  end

end
