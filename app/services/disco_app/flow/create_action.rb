require 'interactor'

module DiscoApp
  module Flow
    class CreateAction

      include Interactor

      delegate :shop, :action_id, :action_run_id, :properties, :action, to: :context

      def call
        create_action
        enqueue_process_action_job
      end

      private

        def create_action
          context.action = shop.flow_actions.create!(
            action_id: action_id,
            action_run_id: action_run_id,
            properties: properties
          )
        rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
          context.fail!
        end

        def enqueue_process_action_job
          ProcessActionJob.perform_later(shop, action)
        end

    end
  end
end
