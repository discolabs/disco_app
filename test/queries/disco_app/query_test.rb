module DiscoApp

  class ShopQuery < GraphQueryBase

    def query_definition
      query do
        shop do
          name
        end
      end
    end

  end

  class QueryTest < ActiveSupport::TestCase

    def setup
      @shop = disco_app_shops(:widget_store)
    end

    def teardown
      @shop = nil
    end

    test 'execute query from GraphiQL Query' do
      VCR.use_cassette('shopify_graph/valid_shop_query', match_requests_on: [:method, :uri]) do
        response = ShopQuery.new(@shop).execute!
        assert_equal 'widgets', response.data.shop.name
      end
    end

    test 'execute query from GraphiQL Query with incorrect token raise Server error' do
      VCR.use_cassette('shopify_graph/bad_request_shop_query', match_requests_on: [:method, :uri]) do
        exception = assert_raises(Graphlient::Errors::ServerError) do
          ShopQuery.new(@shop).execute!
        end
        assert_equal 'the server responded with status 401', exception.message
      end
    end

    test 'execute invalid query from GraphiQL Query raise error' do

      # Redefine method at runtime to trigger error
      query = ShopQuery.new(@shop)
      query.define_singleton_method(:query_definition) do
        query do
          shop do
            name
            potatoe
          end
        end
      end

      exception = assert_raises(Graphlient::Errors::ClientError) do
        query.execute!
      end
      assert_equal "Field 'potatoe' doesn't exist on type 'Shop'", exception.message
    end

  end
end
