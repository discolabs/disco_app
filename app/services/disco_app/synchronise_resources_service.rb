module DiscoApp
  class SynchroniseResourcesService

    PAGE_LIMIT = 250

    attr_reader :shop, :class_name, :since_id

    def self.synchronise_all(shop, class_name, since_id = 0)
      new(shop, class_name, since_id).synchronise_all
    end
  
    def initialize(shop, class_name, since_id)
      @shop = shop
      @since_id = since_id
      @class_name = class_name
    end

    def synchronise_all
      synchronise_page
      finish_or_loop
    end

    private

      attr_reader :shopify_records

      def synchronise_page(_last_shopify_record = since_id)
        @shopify_records = shop.with_api_context do
          synchronise_class::SHOPIFY_API_CLASS.find(:all, params: {
            limit: PAGE_LIMIT,
            since_id: since_id
          })
        end

        shopify_records.each do |shopify_record|
          synchronise_class.synchronise(shop, shopify_record)
        end
      end

      def finish_or_loop
        return if shopify_records.empty? || shopify_records.size < PAGE_LIMIT

        DiscoApp::SynchroniseResourcesJob.perform_later(shop, class_name, shopify_records.last.id)
      end

      def synchronise_class
        @synchronise_class ||= class_name.constantize
      end

  end
end
