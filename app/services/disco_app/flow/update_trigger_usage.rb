require 'interactor'

module DiscoApp
  module Flow
    class UpdateTriggerUsage

      include Interactor

      delegate :shop, :flow_trigger_definition_id, :has_enabled_flow, :timestamp, to: :context
      delegate :trigger_usage, to: :context

      def call
        find_or_create_trigger_usage
        update_trigger_usage
      end

      private

        def find_or_create_trigger_usage
          context.trigger_usage = shop.flow_trigger_usages.create_or_find_by!(
            flow_trigger_definition_id: flow_trigger_definition_id
          )
        rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
          context.fail!
        end

        def update_trigger_usage
          return if existing_timestamp_is_newer?

          trigger_usage.update(
            has_enabled_flow: has_enabled_flow,
            timestamp: timestamp
          )
        end

        def existing_timestamp_is_newer?
          trigger_usage.timestamp.present? && timestamp < trigger_usage.timestamp
        end

    end
  end
end
