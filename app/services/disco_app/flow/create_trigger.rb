require 'interactor'

module DiscoApp
  module Flow
    class CreateTrigger

      include Interactor

      delegate :shop, :title, :resource_name, :resource_url, :properties, :trigger, to: :context

      def call
        create_trigger
        enqueue_process_trigger_job
      end

      private

        def create_trigger
          context.trigger = shop.flow_triggers.create!(
            title: title,
            resource_name: resource_name,
            resource_url: resource_url,
            properties: properties
          )
        end

        def enqueue_process_trigger_job
          ProcessTriggerJob.perform_later(shop, trigger)
        end

    end
  end
end
