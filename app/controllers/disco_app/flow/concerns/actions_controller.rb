module DiscoApp
  module Flow
    module Concerns
      module ActionsController

        extend ActiveSupport::Concern
        include DiscoApp::Flow::Concerns::VerifiesFlowPayload

        def create_flow_action
          DiscoApp::Flow::CreateAction.call(
            shop: @shop,
            action_id: params[:id],
            action_run_id: params[:action_run_id],
            properties: params[:properties]
          )

          head :ok
        end

      end
    end
  end
end
