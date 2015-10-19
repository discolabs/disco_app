require 'test_helper'

class DiscoApp::SubscriptionServiceTest < ActiveSupport::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
    @current_subscription = @shop.current_subscription
  end

  def teardown
    @shop = nil
  end

  test 'subscribing to a new plan deactivates current subscription and swaps to new plan' do
    DiscoApp::SubscriptionService.subscribe(@shop, disco_app_plans(:premium))
    @current_subscription.reload
    assert @current_subscription.replaced?
    assert_equal disco_app_plans(:premium), @shop.current_subscription.plan
  end

  test 'cancelling a plan works' do
    DiscoApp::SubscriptionService.cancel(@shop)
    @current_subscription.reload
    assert @current_subscription.cancelled?
    assert_not @shop.current_subscription
  end

end
