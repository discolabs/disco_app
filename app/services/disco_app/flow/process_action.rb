require 'interactor'

module DiscoApp
  module Flow
    class ProcessAction

      include Interactor

      delegate :action, to: :context
      delegate :action_service_class, to: :context

      def call
        validate_action
        find_action_service_class
        execute_action_service_class
      end

      private

        def validate_action
          context.fail! unless action.pending?
        end

        def find_action_service_class
          context.action_service_class =
            action.action_id.classify.safe_constantize ||
            %(Flow::Actions::#{action.action_id.to_s.classify}).safe_constantize

          return unless action_service_class.nil?

          update_action(false, ["Could not find service class for #{action.action_id}"])
          context.fail!
        end

        def execute_action_service_class
          result = action_service_class.call(shop: action.shop, properties: action.properties)
          update_action(result.success?, result.errors)
        end

        def update_action(success, errors)
          action.update!(
            status: success ? Action.statuses[:succeeded] : Action.statuses[:failed],
            processing_errors: success ? [] : errors,
            processed_at: Time.current
          )
        end

    end
  end
end
