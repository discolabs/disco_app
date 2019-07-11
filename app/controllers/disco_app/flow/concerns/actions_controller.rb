module DiscoApp
  module Flow
    module Concerns
      module ActionsController

        extend ActiveSupport::Concern

        included do
          before_action :verify_flow_action
          before_action :find_shop
          protect_from_forgery with: :null_session
        end

        def create_flow_action
          DiscoApp::Flow::CreateAction.call(
            shop: @shop,
            action_id: params[:id],
            action_run_id: params[:action_run_id],
            properties: params[:properties]
          )

          head :ok
        end

        private

          def verify_flow_action
            return head :unauthorized unless flow_action_is_valid?

            request.body.rewind
          end

          # Shopify Flow action endpoints use the same verification method as webhooks, which is why we reuse this
          # service method here.
          def flow_action_is_valid?
            DiscoApp::WebhookService.valid_hmac?(
              request.body.read.to_s,
              ShopifyApp.configuration.secret,
              request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
            )
          end

          def find_shop
            @shop = DiscoApp::Shop.find_by_shopify_domain!(params[:shopify_domain])
          end

      end
    end
  end
end
