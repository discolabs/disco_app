require 'test_helper'

class DiscoApp::ChargesServiceTest < ActiveSupport::TestCase
  include DiscoApp::Test::ShopifyAPI

  def setup
    @shop = disco_app_shops(:widget_store)
    @subscription = disco_app_subscriptions(:current_widget_store_subscription)
    @new_charge = disco_app_recurring_application_charges(:new_widget_store_subscription_recurring_charge)

    @dev_shop = disco_app_shops(:widget_store_dev)
    @dev_subscription = disco_app_subscriptions(:current_widget_store_dev_subscription)
    @dev_new_charge = disco_app_application_charges(:new_widget_store_dev_subscription_one_time_charge)

    Timecop.freeze
  end

  def teardown
    @shop = nil
    @subscription = nil
    @new_charge = nil

    @dev_shop = nil
    @dev_subscription = nil
    @dev_new_charge = nil

    Timecop.return

    WebMock.reset!
  end

  test 'creating a new charge for a recurring subscription is successful' do
    res = { "recurring_application_charge": { "name": "Basic",
                    "price": "9.99",
                    "trial_days": 14,
                    "return_url": /^https:\/\/test\.example\.com\/subscriptions\/304261385\/charges\/53297050(1|2)\/activate$/,
                    "test": true 
      } }
    stub_request(:post, "#{@shop.admin_url}/recurring_application_charges.json")
      .with(body: res
    ).to_return(status: 201, body:api_fixture("widget_store/charges/create_recurring_application_charge_response").to_json)

    new_charge = DiscoApp::ChargesService.create(@shop, @subscription)
    assert_equal 654381179, new_charge.shopify_id
    assert_equal 'https://apple.myshopify.com/admin/charges/654381179/confirm_recurring_application_charge?signature=BAhpBHsQASc%3D--b2e90c6e4e94fbae15a464c566a31a1c23e6bffa', new_charge.confirmation_url
  end

  test 'activating a pending recurring charge is not successful' do
    stub_api_request(:get, "#{@shop.admin_url}/recurring_application_charges/654381179.json", 'widget_store/charges/get_pending_recurring_application_charge')
    assert_not DiscoApp::ChargesService.activate(@shop, @new_charge)
    assert @new_charge.pending?
  end

  test 'activating a declined recurring charge is not successful' do
    stub_api_request(:get, "#{@shop.admin_url}/recurring_application_charges/654381179.json", 'widget_store/charges/get_declined_recurring_application_charge')
    assert_not DiscoApp::ChargesService.activate(@shop, @new_charge)
    assert @new_charge.declined?
  end

  test 'activating an accepted recurring charge is successful and cancels any existing recurring charges' do
    stub_api_request(:get, "#{@shop.admin_url}/recurring_application_charges/654381179.json", 'widget_store/charges/get_accepted_recurring_application_charge')
    stub_api_request(:post, "#{@shop.admin_url}/recurring_application_charges/654381179/activate.json", 'widget_store/charges/activate_recurring_application_charge')

    old_charge = @subscription.active_charge
    assert old_charge.active?

    assert DiscoApp::ChargesService.activate(@shop, @new_charge)
    assert @new_charge.active?

    old_charge.reload
    assert old_charge.cancelled?
  end

  test 'activating an accepted recurring charge cancels other recurring charges' do
    stub_api_request(:get, "#{@shop.admin_url}/recurring_application_charges/654381179.json", 'widget_store/charges/get_accepted_recurring_application_charge')
    stub_api_request(:post, "#{@shop.admin_url}/recurring_application_charges/654381179/activate.json", 'widget_store/charges/activate_recurring_application_charge')

    assert DiscoApp::ChargesService.activate(@shop, @new_charge)
    assert @new_charge.active?
  end

  test 'creating a new charge for a one-time subscription is successful' do
    stub_api_request(:post, "#{@dev_shop.admin_url}/application_charges.json", 'widget_store/charges/create_application_charge')

    new_charge = DiscoApp::ChargesService.create(@dev_shop, @dev_subscription)
    assert_equal 1012637323, new_charge.shopify_id
    assert_equal 'https://apple.myshopify.com/admin/charges/1012637323/confirm_application_charge?signature=BAhpBIueWzw%3D--0ea1abacaf9d6fd538b7e9a7023e9b71ce1c7e98', new_charge.confirmation_url
  end

  test 'activating a pending one-time charge is not successful' do
    stub_api_request(:get, "#{@dev_shop.admin_url}/application_charges/1012637323.json", 'widget_store/charges/get_pending_application_charge')

    assert_not DiscoApp::ChargesService.activate(@dev_shop, @dev_new_charge)
    assert @dev_new_charge.pending?
  end

  test 'activating a declined one-time charge is not successful' do
    stub_api_request(:get, "#{@dev_shop.admin_url}/application_charges/1012637323.json", 'widget_store/charges/get_declined_application_charge')

    assert_not DiscoApp::ChargesService.activate(@dev_shop, @dev_new_charge)
    assert @dev_new_charge.declined?
  end

  test 'activating an accepted one-time charge is successful' do
    stub_api_request(:get, "#{@dev_shop.admin_url}/application_charges/1012637323.json", 'widget_store/charges/get_accepted_application_charge')
    stub_api_request(:post, "#{@dev_shop.admin_url}/application_charges/1012637323/activate.json", 'widget_store/charges/activate_application_charge')

    assert DiscoApp::ChargesService.activate(@dev_shop, @dev_new_charge)
    assert @dev_new_charge.active?
  end

end
