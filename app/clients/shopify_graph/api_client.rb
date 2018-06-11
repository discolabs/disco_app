# frozen_string_literal: true
require 'graphlient'

# TODO: Add error rescuing from Graphlient::Client errors
# TODO: Implement Rate limiting based on extensions cost

module ShopifyGraph
  class ApiClient < ::Graphlient::Client

    GRAPHQL_VERSION = 'GraphQL/1.0'
    # Load schema from disk to avoid extra heavy query at client init
    SHOPIFY_GRAPH_SCHEMA_PATH = 'lib/shopify/api_schema.json'

    attr_reader :shop

    def initialize(shop)
      @shop = shop
      super(
        shop_graph_url,
        headers: shop_headers,
        schema_path: SHOPIFY_GRAPH_SCHEMA_PATH
      )
    end

    ##
    # Replace schema in disk by newer one if it changes
    def refresh_schema!
      schema.dump!
    end

    private

      def shop_headers
        {
          "User-Agent": GRAPHQL_VERSION,
          "X-Shopify-Access-Token": shop.shopify_token
        }
      end

      def shop_graph_url
        "https://#{shop.shopify_domain}/admin/api/graphql.json"
      end

  end
end
