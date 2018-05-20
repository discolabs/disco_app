require 'test_helper'
require 'graphlient'

module ShopifyGraph
  class ApiClientTest < ActiveSupport::TestCase

    def setup
      @shop = disco_app_shops(:widget_store)
      @graph_client = @shop.shopify_graph_client
    end

    def teardown
      @shop = nil
      @graph_client = nil
    end

    test 'query will trigger error at parsing time before request is made' do
      error = assert_raises(Graphlient::Errors::ClientError) do
        parsed_invalid_test_query
      end
      assert_equal "Field 'potatoe' doesn't exist on type 'Shop'", error.message
    end

    test 'query with shop context is successful' do
      VCR.use_cassette('shopify_graph/shop_query', match_requests_on: [:method, :uri]) do
        response = @graph_client.execute(parsed_valid_test_query)
        assert_equal 'widgets', response.data.shop.name
      end
    end

    private

      def parsed_valid_test_query
        @graph_client.parse do
          query do
            shop do
              name
            end
          end
        end
      end

      def parsed_invalid_test_query
        @graph_client.parse do
          query do
            shop do
              name
              potatoe
            end
          end
        end
      end

  end
end
