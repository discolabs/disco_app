require 'test_helper'

class DiscoApp::ChargesControllerTest < ActionController::TestCase

  include ActiveJob::TestHelper
  include DiscoApp::Test::ShopifyAPI

  def setup
    @shop = disco_app_shops(:widget_store)
    @current_subscription = disco_app_subscriptions(:current_widget_store_subscription)
    @new_charge = disco_app_recurring_application_charges(:new_widget_store_subscription_recurring_charge)
    @routes = DiscoApp::Engine.routes
    log_in_as(@shop)
    @shop.installed!
  end

  def teardown
    @shop = nil
    @current_subscription = nil
    WebMock.reset!
  end

  test 'non-logged in user is redirected to the login page' do
    log_out
    get :new, params: { subscription_id: @current_subscription }
    assert_redirected_to ShopifyApp::Engine.routes.url_helpers.login_path + "?" + { return_to: session[:return_to] }.to_query
  end

  test 'logged-in, never installed user is redirected to the install page' do
    @shop.never_installed!
    get :new, params: { subscription_id: @current_subscription }
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.install_path
  end

  test 'user with paid-for current subscription can not access page' do
    get :new, params: { subscription_id: @current_subscription }
    assert_redirected_to Rails.application.routes.url_helpers.root_path
  end

  test 'user with unpaid current subscription can access page' do
    @current_subscription.active_charge.destroy
    get :new, params: { subscription_id: @current_subscription }
    assert_response :ok
  end

  test 'user with unpaid current subscription can create new charge and is redirected to confirmation url' do
    res = { "recurring_application_charge": { "name": 'Basic',
                                              "price": '9.99',
                                              "trial_days": 14,
                                              "return_url": %r{^https://test\.example\.com/subscriptions/304261385/charges/53297050(1|2)/activate$},
                                              "test": true } }
    stub_request(:post, "#{@shop.admin_url}/recurring_application_charges.json")
      .with(body: res).to_return(status: 201, body: api_fixture('widget_store/charges/create_second_recurring_application_charge_response').to_json)

    @current_subscription.active_charge.destroy
    post :create, params: { subscription_id: @current_subscription }
    assert_redirected_to 'https://apple.myshopify.com/admin/charges/654381179/confirm_recurring_application_charge?signature=BAhpBHsQASc%3D--b2e90c6e4e94fbae15a464c566a31a1c23e6bffa'
  end

  test 'user trying to activate charge for invalid gets not found and hence 404' do
    assert_raises ActiveRecord::RecordNotFound do
      get :activate, params: { subscription_id: '123', id: '456', charge_id: '789' }
    end
  end

  test 'user trying to activate invalid charge for valid subscription gets redirected to new charge page for that subscription' do
    @current_subscription.active_charge.destroy
    get :activate, params: { subscription_id: @current_subscription, id: '456', charge_id: '789' }
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.new_subscription_charge_path(@current_subscription)
  end

  test 'user trying to activate pending charge is redirected back to new charge page' do
    stub_api_request(:get, "#{@shop.admin_url}/recurring_application_charges/654381179.json", 'widget_store/charges/get_pending_recurring_application_charge')

    @current_subscription.active_charge.destroy
    get :activate, params: { subscription_id: @current_subscription, id: @new_charge.id, charge_id: @new_charge.shopify_id }
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.new_subscription_charge_path(@current_subscription)
  end

  test 'user trying to activate declined charge is redirected back to new charge page' do
    stub_api_request(:get, "#{@shop.admin_url}/recurring_application_charges/654381179.json", 'widget_store/charges/get_declined_recurring_application_charge')

    @current_subscription.active_charge.destroy
    get :activate, params: { subscription_id: @current_subscription, id: @new_charge.id, charge_id: @new_charge.shopify_id }
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.new_subscription_charge_path(@current_subscription)
  end

  test 'user trying to activate accepted charge succeeds and is redirected to the root page' do
    stub_api_request(:get, "#{@shop.admin_url}/recurring_application_charges/654381179.json", 'widget_store/charges/get_accepted_recurring_application_charge')
    stub_api_request(:post, "#{@shop.admin_url}/recurring_application_charges/654381179/activate.json", 'widget_store/charges/activate_recurring_application_charge')

    @current_subscription.active_charge.destroy
    get :activate, params: { subscription_id: @current_subscription, id: @new_charge.id, charge_id: @new_charge.shopify_id }
    assert_equal @new_charge, @current_subscription.active_charge
    assert_redirected_to Rails.application.routes.url_helpers.root_path
  end

end
