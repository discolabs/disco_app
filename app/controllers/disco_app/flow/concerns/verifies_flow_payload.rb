module DiscoApp
  module Flow
    module Concerns
      module VerifiesFlowPayload

        extend ActiveSupport::Concern

        included do
          before_action :verify_flow_payload
          before_action :find_shop
          protect_from_forgery with: :null_session
        end

        private

          def verify_flow_payload
            return head :unauthorized unless flow_payload_is_valid?

            request.body.rewind
          end

          # Shopify Flow action and trigger usage update endpoints use the same
          # verification as webhooks, which is why we reuse this service method here.
          def flow_payload_is_valid?
            DiscoApp::WebhookService.valid_hmac?(
              request.body.read.to_s,
              ShopifyApp.configuration.secret,
              request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
            )
          end

          def find_shop
            @shop = DiscoApp::Shop.find_by!(shopify_domain: params[:shopify_domain])
          end

      end
    end
  end
end
