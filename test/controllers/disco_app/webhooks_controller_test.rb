require 'test_helper'

class DiscoApp::WebhooksControllerTest < ActionController::TestCase

  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
    @routes = DiscoApp::Engine.routes
  end

  def teardown
    @shop = nil
  end

  test 'webhook request without authentication information returns unauthorized' do
    body = webhook_fixture('app_uninstalled')
    post :process_webhook, body: body
    assert_response :unauthorized
  end

  test 'webhook request with no HMAC returns unauthorized' do
    body = webhook_fixture('app_uninstalled')
    @request.headers['HTTP_X_SHOPIFY_TOPIC'] = :'app/uninstalled'
    @request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'] = @shop.shopify_domain
    post :process_webhook, body: body
    assert_response :unauthorized
  end

  test 'webhook request with invalid HMAC returns unauthorized' do
    body = webhook_fixture('app_uninstalled')
    @request.headers['HTTP_X_SHOPIFY_TOPIC'] = :'app/uninstalled'
    @request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'] = @shop.shopify_domain
    @request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'] = '0000'
    post :process_webhook, body: body
    assert_response :unauthorized
  end

  test 'webhook request with valid HMAC returns OK' do
    body = webhook_fixture('app_uninstalled')
    @request.headers['HTTP_X_SHOPIFY_TOPIC'] = :'app/uninstalled'
    @request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'] = @shop.shopify_domain
    @request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'] = DiscoApp::WebhookService.calculated_hmac(body, ShopifyApp.configuration.secret)
    post :process_webhook, body: body
    assert_response :ok
  end

  test 'app uninstalled job queued when app/uninstalled webhook arrives' do
    body = webhook_fixture('app_uninstalled')
    @request.headers['HTTP_X_SHOPIFY_TOPIC'] = :'app/uninstalled'
    @request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'] = @shop.shopify_domain
    @request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'] = DiscoApp::WebhookService.calculated_hmac(body, ShopifyApp.configuration.secret)

    assert_enqueued_with(job: DiscoApp::AppUninstalledJob) do
      post :process_webhook, body: body
    end
  end

end
