require 'interactor'

module DiscoApp
  module Flow
    class ProcessTrigger

      include Interactor

      delegate :trigger, to: :context
      delegate :api_success, :api_errors, to: :context

      def call
        validate_trigger
        make_api_request
        update_trigger
        fail_if_errors_present
      end

      private

        def validate_trigger
          context.fail! unless trigger.pending?
        end

        def make_api_request
          context.api_success, context.api_errors = api_client.create_flow_trigger(
            trigger.title,
            trigger.resource_name,
            trigger.resource_url,
            trigger.properties
          )
        end

        def update_trigger
          trigger.update!(
            status: api_success ? Trigger.statuses[:succeeded] : Trigger.statuses[:failed],
            processing_errors: api_success ? [] : api_errors,
            processed_at: Time.current
          )
        end

        def fail_if_errors_present
          context.fail! unless api_success
        end

        def api_client
          @api_client ||= DiscoApp::GraphqlClient.new(trigger.shop)
        end

    end
  end
end
