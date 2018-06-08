require 'graphlient'

module ShopifyGraph
  class QueryBase

    include Graphlient::Extensions::Query

    attr_reader :shop

    ##
    # Shop always needs to be provided as it is required to perform
    # the dynamic query based on the shop shopify_domain and token
    def initialize(shop)
      @shop = shop
    end

    ##
    # Parse and execute query defined in the query_definition of
    # a given child class
    def execute!(variables = {})
      graph_client.execute(query_definition.to_s, variables)
    end

    ##
    # Defines the query
    # Query can be define using the block syntax, either with do..end or {}
    # e.g: query {
    #        shop {
    #          name
    #        }
    #      }
    # TODO: Implement support for HEREDOC
    def query_definition
      raise NotImplementedError
    end

    private

      def graph_client
        @graph_client ||= shop.shopify_graph_client
      end

  end
end
