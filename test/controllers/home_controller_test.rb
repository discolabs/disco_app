require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
    @current_subscription = disco_app_subscriptions(:current_widget_store_subscription)
    @current_recurring_charge = disco_app_recurring_application_charges(:current_widget_store_subscription_recurring_charge)
    log_in_as(@shop)
  end

  def teardown
    @shop = nil
    @current_subscription = nil
  end

  test 'non-logged in user is redirected to the login page' do
    log_out
    get(:index)
    assert_redirected_to ShopifyApp::Engine.routes.url_helpers.login_path
  end

  test 'logged-in, never installed user is redirected to the install page' do
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.install_path
  end

  test 'logged-in, awaiting install user is redirected to the installing page' do
    @shop.awaiting_install!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.installing_path
  end

  test 'logged-in, installing user is redirected to the installing page' do
    @shop.installing!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.installing_path
  end

  test 'logged-in, awaiting uninstall user is redirected to the uninstalling page' do
    @shop.awaiting_uninstall!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.uninstalling_path
  end

  test 'logged-in, uninstalling user is redirected to the uninstalling page' do
    @shop.uninstalling!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.uninstalling_path
  end

  test 'logged-in, uninstalled user is redirected to the install page' do
    @shop.uninstalled!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.install_path
  end

  test 'logged-in, installed user with no current subscription is redirected to new subscription page' do
    @shop.installed!
    @current_subscription.destroy
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.new_subscription_path
  end

  test 'logged-in, installed user with no cancelled subscription is redirected to new subscription page' do
    @shop.installed!
    @current_subscription.cancelled!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.new_subscription_path
  end

  test 'logged-in, installed user with current but unpaid subscription is redirected to new charges page' do
    @shop.installed!
    @current_recurring_charge.destroy
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.new_subscription_charge_path(@current_subscription)
  end

  test 'logged-in, installed user with current subscription with declined charge is redirected to new charges page' do
    @shop.installed!
    @current_recurring_charge.declined!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.new_subscription_charge_path(@current_subscription)
  end

  test 'logged-in, installed user with a current and paid subscription is able to access the page' do
    @shop.installed!
    get(:index)
    assert_response :success
  end

end
