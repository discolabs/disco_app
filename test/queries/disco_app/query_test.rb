module DiscoApp
  class QueryTest < ActiveSupport::TestCase

    def setup
      @shop = disco_app_shops(:widget_store)
    end

    def teardown
      @shop = nil
    end

    test 'execute query from GraphiQL Query' do

      class ShopQuery < GraphQueryBase
        def query_definition
          query do
            shop do
              name
            end
          end
        end
      end

      VCR.use_cassette('shopify_graph/shop_query', match_requests_on: [:method, :uri]) do
        response = ShopQuery.new(@shop).execute!
        assert_equal 'widgets', response.data.shop.name
      end
    end

  end
end
