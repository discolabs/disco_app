require 'test_helper'

class ProxyControllerTest < ActionController::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
    @secret = ShopifyApp.configuration.secret
  end

  def teardown
    @shop = nil
    @secret = nil
  end

  test 'app proxy request without authentication information returns unauthorized' do
    get(:index)
    assert_response :unauthorized
  end

  test 'app proxy request with incorrect authentication information returns unauthorized' do
    get :index, params: proxy_params(shop: @shop.shopify_domain).merge(signature: 'invalid_signature')
    assert_response :unauthorized
  end

  test 'app proxy request with correct authentication information returns ok and has shop context' do
    get :index, params: proxy_params(shop: @shop.shopify_domain)
    assert_response :ok
    assert_equal @shop, assigns(:shop)
  end

  test 'app proxy request with correct authentication information but unknown shop returns 404' do
    get :index, params: proxy_params(shop: 'unknown.myshopify.com')
    assert_response :not_found
  end

  private

    def proxy_params(**params)
      params.merge(signature: DiscoApp::ProxyService.calculated_signature(params, @secret))
    end

end
