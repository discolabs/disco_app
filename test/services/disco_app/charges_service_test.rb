require 'test_helper'

class DiscoApp::ChargesServiceTest < ActiveSupport::TestCase
  include DiscoApp::Test::ShopifyAPI

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

  test 'creating a new charge for a recurring subscription is successful' do
    stub_api_request(:post, "#{@shop.admin_url}/recurring_application_charges.json", 'widget_store/charges/create_recurring_application_charge')

    new_charge = DiscoApp::ChargesService.create(@shop, @subscription)
    assert_equal 654381179, new_charge.shopify_id
    assert_equal 'https://apple.myshopify.com/admin/charges/654381179/confirm_recurring_application_charge?signature=BAhpBHsQASc%3D--b2e90c6e4e94fbae15a464c566a31a1c23e6bffa', new_charge.confirmation_url
  end

  test 'creating a new charge for a one-off subscription is successful' do
    stub_api_request(:post, "#{@shop.admin_url}/application_charges.json", 'widget_store/charges/create_application_charge')

    subscription = DiscoApp::SubscriptionService.subscribe(@shop, disco_app_plans(:lifetime))

    new_charge = DiscoApp::ChargesService.create(@shop, subscription)
    assert_equal 1012637323, new_charge.shopify_id
    assert_equal 'https://apple.myshopify.com/admin/charges/1012637323/confirm_application_charge?signature=BAhpBIueWzw%3D--0ea1abacaf9d6fd538b7e9a7023e9b71ce1c7e98', new_charge.confirmation_url
  end

end
