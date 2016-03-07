require 'test_helper'

class SynchronisesTest < ActionDispatch::IntegrationTest
  fixtures :all

  def setup
    @shop = disco_app_shops(:widget_store)
    @routes = DiscoApp::Engine.routes
  end

  def teardown
    @shop = nil
  end

  test 'product is created when product created webhooks is received' do
    post_webhook('product_created', :'products/create')
    # Assert the product was created locally.
    assert_equal 632910392, Product.last.id
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
