module DiscoApp::Concerns::Synchronises
  extend ActiveSupport::Concern

  class_methods do

    # Define the number of resources per page to fetch.
    SYNCHRONISES_PAGE_LIMIT = 250

    def should_synchronise?(shop, data)
      true
    end

    def synchronise_by(shop, data)
      { id: data[:id] }
    end

    def synchronise(shop, data)
      if data.is_a?(ShopifyAPI::Base)
        data = ActiveSupport::JSON.decode(data.to_json)
      end
      data = data.with_indifferent_access

      return unless should_synchronise?(shop, data)

      begin
        instance = self.find_or_create_by!(self.synchronise_by(shop, data)) do |instance|
          instance.shop = shop
          instance.data = data
        end
      rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
        retry
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

      self.where(shop: shop, id: data[:id]).destroy_all
    end

    def synchronise_all(shop, params = {})
      resource_count = shop.with_api_context { self::SHOPIFY_API_CLASS.count(params) }

      (1..(resource_count / SYNCHRONISES_PAGE_LIMIT.to_f).ceil).each do |page|
        DiscoApp::SynchroniseResourcesJob.perform_later(shop, self.name, params.merge(page: page, limit: SYNCHRONISES_PAGE_LIMIT))
      end
    end

  end

  included do

    # Override the "read" data attribute to allow indifferent access.
    def data
      read_attribute(:data).with_indifferent_access
    end

  end

end
