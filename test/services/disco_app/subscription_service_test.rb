require 'test_helper'

class DiscoApp::SubscriptionServiceTest < ActiveSupport::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
    @subscription = disco_app_subscriptions(:current_widget_store_subscription)
    Timecop.freeze
  end

  def teardown
    @shop = nil
    @subscription = nil
    Timecop.return
  end

  test 'subscribing to a new plan deactivates current subscription and swaps to new plan' do
    DiscoApp::SubscriptionService.subscribe(@shop, disco_app_plans(:premium))
    @subscription.reload
    assert @subscription.cancelled?
    assert_equal disco_app_plans(:premium), @shop.current_subscription.plan
  end

  test 'subscribing to a new plan works for a shop without a subscription' do
    @subscription.destroy
    DiscoApp::SubscriptionService.subscribe(@shop, disco_app_plans(:premium))
    assert_equal disco_app_plans(:premium), @shop.current_subscription.plan
  end

  test 'new subscription for a plan without a trial period created correctly' do
    new_subscription = DiscoApp::SubscriptionService.subscribe(@shop, disco_app_plans(:comped))
    assert new_subscription.active?
    assert_equal nil, new_subscription.trial_start_at
    assert_equal nil, new_subscription.trial_end_at
  end

  test 'new subscription for a plan with a trial period created correctly' do
    new_subscription = DiscoApp::SubscriptionService.subscribe(@shop, disco_app_plans(:premium))
    assert new_subscription.trial?
    assert_equal Time.now, new_subscription.trial_start_at
    assert_equal 28.days.from_now, new_subscription.trial_end_at
  end

end
