require 'interactor'

module DiscoApp
  module Flow
    class CreateTrigger

      include Interactor

      delegate :shop, :title, :resource, :properties, :trigger, to: :context

      def call
        create_trigger
        enqueue_process_trigger_job
      end

      private

        def create_trigger
          context.trigger = shop.flow_triggers.create!(
            title: title,
            resource_name: resource.flow_name,
            resource_url: resource.flow_url,
            properties: properties
          )
        end

        def enqueue_process_trigger_job
          ProcessTriggerJob.perform_later(shop, trigger)
        end

    end
  end
end
