require 'test_helper'

module DiscoApp
  module Flow
    class TriggerUsageControllerTest < ActionController::TestCase

      def setup
        @shop = disco_app_shops(:widget_store)
        @routes = DiscoApp::Engine.routes
      end

      def teardown
        @shop = nil
      end

      test 'trigger usage request with no hmac returns unauthorized and does not process' do
        body = webhook_fixture('flow/trigger_usage')
        post :update_trigger_usage, body: body, as: :json
        assert_response :unauthorized
        assert_equal 0, @shop.flow_trigger_usages.count
      end

      test 'trigger usage request with invalid hmac returns unauthorized and does not process' do
        body = webhook_fixture('flow/trigger_usage')
        @request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'] = '4b5a5762352c9e9a8f4307f0e0ce6919370f1602bdedb331db3b7203de5ade6f'
        post :update_trigger_usage, body: body, as: :json
        assert_response :unauthorized
        assert_equal 0, @shop.flow_trigger_usages.count
      end

      test 'trigger usage request with valid hmac returns ok and does process' do
        body = webhook_fixture('flow/trigger_usage')
        @request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'] = DiscoApp::WebhookService.calculated_hmac(body, ShopifyApp.configuration.secret)
        post :update_trigger_usage, body: body, as: :json
        assert_response :ok
        assert_equal 1, @shop.flow_trigger_usages.count
      end

    end
  end
end
