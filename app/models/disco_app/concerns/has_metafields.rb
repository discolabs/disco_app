module DiscoApp::Concerns::HasMetafields
  extend ActiveSupport::Concern

  included do

    # Write multiple metafields for this object in a single call.
    #
    # Expects an argument in a nested hash structure with :namespace => :key =>
    # :value, eg:
    #
    #   Product.write_metafields(myapp: {
    #      key1: 'value1',
    #      key2: 'value2'
    #   })
    #
    # This method assumes that it is being called within a valid Shopify API
    # session context, eg @shop.temp { ... }.
    #
    # It also assumes that the including class has defined the appropriate value
    # for SHOPIFY_API_CLASS and that calling the `id` method on the instance
    # will return the relevant object's Shopify ID.
    #
    # Returns true on success, false otherwise.
    def write_metafields(metafields)
      self.class::SHOPIFY_API_CLASS.new(
        id: id,
        metafields: metafields.map do |namespace, keys|
          keys.map do |key, value|
            ShopifyAPI::Metafield.new(
              namespace: namespace,
              key: key,
              value: value,
              value_type: value.is_a?(Integer) ? :integer : :string
            )
          end
        end.flatten
      ).save
    end

  end

end
