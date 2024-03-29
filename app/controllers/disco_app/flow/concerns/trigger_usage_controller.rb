module DiscoApp
  module Flow
    module Concerns
      module TriggerUsageController

        extend ActiveSupport::Concern
        include DiscoApp::Flow::Concerns::VerifiesFlowPayload

        def update_trigger_usage
          DiscoApp::Flow::UpdateTriggerUsage.call(
            shop: @shop,
            flow_trigger_definition_id: params[:flow_trigger_definition_id],
            has_enabled_flow: params[:has_enabled_flow],
            timestamp: parsed_timestamp
          )

          head :ok
        end

        private

          def parsed_timestamp
            Time.parse(params[:timestamp])
          end

      end
    end
  end
end
