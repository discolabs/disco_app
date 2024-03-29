module DiscoApp
  module Concerns
    module HasMetafields

      extend ActiveSupport::Concern

      included do
        # Write multiple metafields for this object in a single call.
        #
        # Expects an argument in a nested hash structure with :namespace => :key => :value, eg:
        #
        #   Product.write_metafields(myapp: {
        #     key1: 'value1',
        #     key2: 3,
        #     key3: { 'value_key' => 'value_value' }
        #   })
        #
        # String, integer and hash values will have their value type detected and set accordingly.
        #
        # This method assumes that it is being called within a valid Shopify API session context,
        # eg @shop.with_api_context { ... }.
        #
        # It also assumes that the including class has defined the appropriate value for
        # SHOPIFY_API_CLASS.
        #
        # To avoid an issue with trying to set metafield values for namespace and key pairs that
        # already exist, this method also performs a lookup of existing metafields as part of the
        # write process and ensures we set the corresponding metafield ID on the update call if
        # needed.
        #
        # Returns true on success, raises an exception otherwise.
        def write_metafields(metafields)
          return write_shop_metafields(metafields) if shopify_api_class_is_shop?

          write_resource_metafields(metafields)
        end

        # Writing shop metafields is a special case - they need to be saved one by one.
        def write_shop_metafields(metafields)
          build_metafields(metafields).all?(&:save!)
        end

        # Writing regular resource metafields can be done in a single request.
        def write_resource_metafields(metafields)
          self.class::SHOPIFY_API_CLASS.new(
            id: id,
            metafields: build_metafields(metafields)
          ).save!
        end

        # Give a nested hash of metafields in the format described above, return an array of
        # corresponding ShopifyAPI::Metafield instances.
        def build_metafields(metafields)
          metafields.flat_map do |namespace, keys|
            keys.map do |key, value|
              ShopifyAPI::Metafield.new(
                id: existing_metafield_id(namespace, key),
                namespace: namespace,
                key: key,
                value: build_value(value),
                value_type: build_value_type(value)
              )
            end
          end
        end

        # Return the metafield value based on the provided value.
        def build_value(value)
          return value.to_json if value.is_a?(Hash)

          value
        end

        # Return the metafield type based on the provided value type.
        def build_value_type(value)
          return :json_string if value.is_a?(Hash)
          return :integer if value.is_a?(Integer)

          :string
        end

        # Given a namespace and key, attempt to find the ID of a corresponding metafield in the
        # given set of existing metafields.
        def existing_metafield_id(namespace, key)
          existing_metafields.find do |existing_metafield|
            (existing_metafield.namespace.to_sym == namespace.to_sym) && (existing_metafield.key.to_sym == key.to_sym)
          end&.id
        end

        # Fetch and cache existing metafields for this object from the Shopify API.
        def existing_metafields
          @existing_metafields ||= begin
            self.class::SHOPIFY_API_CLASS.new(id: id).metafields
          end
        end

        def shopify_api_class_is_shop?
          self.class::SHOPIFY_API_CLASS == ShopifyAPI::Shop
        end
      end

    end
  end
end
