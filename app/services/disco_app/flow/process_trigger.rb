require 'interactor'

module DiscoApp
  module Flow
    class ProcessTrigger

      include Interactor

      delegate :trigger, to: :context
      delegate :api_success, :api_errors, to: :context

      def call
        validate_trigger
        make_api_request unless trigger_not_in_use?
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
            status: trigger_status,
            processing_errors: processing_errors,
            processed_at: Time.current
          )
        end

        def trigger_status
          return Trigger.statuses[:skipped] if trigger_not_in_use?

          api_success ? Trigger.statuses[:succeeded] : Trigger.statuses[:failed]
        end

        def processing_errors
          return [] if trigger_not_in_use?
          return [] if api_success
          api_errors
        end

        def fail_if_errors_present
          context.fail! unless trigger_not_in_use? || api_success
        end

        def api_client
          @api_client ||= DiscoApp::GraphqlClient.new(trigger.shop)
        end

        def trigger_not_in_use?
          trigger_usage.present? && !trigger_usage.has_enabled_flow?
        end

        def trigger_usage
          @trigger_usage ||= TriggerUsage.find_by(shop: trigger.shop, flow_trigger_definition_id: trigger.title)
        end

    end
  end
end
