require 'test_helper'

class DiscoApp::SubscriptionsControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
    @current_subscription = disco_app_subscriptions(:current_widget_store_subscription)
    @routes = DiscoApp::Engine.routes
    log_in_as(@shop)
    @shop.installed!
  end

  def teardown
    @shop = nil
  end

  test 'non-logged in user is redirected to the login page' do
    log_out
    get(:new)
    assert_redirected_to ShopifyApp::Engine.routes.url_helpers.login_path
  end

  test 'logged-in, never installed user is redirected to the install page' do
    @shop.never_installed!
    get(:new)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.install_path
  end

  test 'logged-in, installed user with no current subscription can access page' do
    @current_subscription.destroy
    get(:new)
    assert_response :ok
  end

  test 'logged-in, installed user with current subscription can access page' do
    get(:new)
    assert_response :ok
  end

  test 'logged-in, installed user with current subscription can create new subscription' do
    post(:create, subscription: { plan: disco_app_plans(:premium) })
    assert_redirected_to Rails.application.routes.url_helpers.root_path
    assert_equal disco_app_plans(:premium), @shop.current_plan
  end

  test 'logged-in, installed user with no subscription can create new subscription' do
    @current_subscription.destroy
    post(:create, subscription: { plan: disco_app_plans(:premium) })
    assert_redirected_to Rails.application.routes.url_helpers.root_path
    assert_equal disco_app_plans(:premium), @shop.current_plan
  end

  test 'logged-in, installed user with current subscription can not create new subscription for unavailable plan' do
    post(:create, subscription: { plan: disco_app_plans(:cheapo) })
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.new_subscription_path
    assert_equal @current_subscription, @shop.current_subscription
  end

end
