require 'test_helper'

module DiscoApp
  class ShopTest < ActiveSupport::TestCase

    def setup
      @shop = disco_app_shops(:widget_store)
    end

    def teardown
      @shop = nil
    end

    test 'shops can be extended via concerns' do
      assert_equal 'Australia', @shop.country.name
    end

  end
end
