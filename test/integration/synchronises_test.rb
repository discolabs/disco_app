require 'test_helper'

class SynchronisesTest < ActionDispatch::IntegrationTest
  fixtures :all

  def setup
    @shop = disco_app_shops(:widget_store)
    @product = products(:ipod)
    @routes = DiscoApp::Engine.routes
  end

  def teardown
    @shop = nil
  end

  test 'new product is created when product created webhook is received' do
    post_webhook('product_created', :'products/create')

    # Assert the product was created locally, with the correct attributes.
    product = Product.find(632910392)
    assert_equal 'IPod Nano - 8GB', product.data[:title]
  end

  test 'existing product is updated when product updated webhook is received' do
    assert_equal({}, @product.data)

    post_webhook('product_updated', :'products/update')

    # Assert the product was updated locally, with the correct attributes.
    @product.reload
    assert_equal 632910393, @product.id
    assert_equal 'IPod Nano - 8GB', @product.data[:title]
  end

  test 'existing product is deleted when product deleted webhook is received' do
    post_webhook('product_deleted', :'products/delete')
    assert_equal 0, Product.count
  end

  test 'cart with token for id is updated when cart updated webhook is received' do
    post_webhook('cart_updated', :'carts/update')

    # Assert the cart data was correctly updated
    assert_equal 3200.0, carts(:cart).total_price
  end

  test 'shopify api model still allows synchronisation' do
    assert_equal({}, @product.data)

    shopify_product = ShopifyAPI::Product.new(ActiveSupport::JSON.decode(webhook_fixture('product_updated')))
    Product.synchronise(@shop, shopify_product)

    # Assert the product was updated locally, with the correct attributes.
    @product.reload
    assert_equal 632910393, @product.id
    assert_equal 'IPod Nano - 8GB', @product.data[:title]
  end

  private

    def webhooks_url
      DiscoApp::Engine.routes.url_helpers.webhooks_url
    end

    def post_webhook(fixture_name, webhook_topic)
      body = webhook_fixture(fixture_name)
      post(webhooks_url, body, {
        HTTP_X_SHOPIFY_TOPIC: webhook_topic,
        HTTP_X_SHOPIFY_SHOP_DOMAIN: @shop.shopify_domain,
        HTTP_X_SHOPIFY_HMAC_SHA256: DiscoApp::WebhookService.calculated_hmac(body, ShopifyApp.configuration.secret)
      })
    end

end
