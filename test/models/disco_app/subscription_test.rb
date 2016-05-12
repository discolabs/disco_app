require 'test_helper'

class DiscoApp::SubscriptionTest < ActiveSupport::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
  end

  def teardown
    @shop = nil
  end

  test 'changing the amount on a subscription cancels its charge' do
    assert @shop.current_subscription.active_charge?
    @shop.current_subscription.update(amount: 1138)
    assert_not @shop.current_subscription.active_charge?
  end

end
