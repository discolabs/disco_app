require 'test_helper'

class DiscoApp::ShopTest < ActiveSupport::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
  end

  def teardown
    @shop = nil
  end

  test 'shops can be extended via concerns' do
    assert_equal 'Australia', @shop.country.name
  end

  test 'can fetch a list of all of a shops subscriptions' do
    assert_equal 2, @shop.subscriptions.size
  end

  test 'can fetch a shops current subscription' do
    assert_equal 1, @shop.subscriptions.active.size
    assert @shop.current_subscription?
    assert_equal disco_app_subscriptions(:current_widget_store_subscription), @shop.current_subscription
  end

end
