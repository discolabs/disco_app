require 'test_helper'

module DiscoApp
  module Flow
    class CreateTriggerTest < ActiveSupport::TestCase

      include ActiveJob::TestHelper

      def setup
        @shop = disco_app_shops(:widget_store)
      end

      def teardown
        @shop = nil
      end

      test 'call to create flow trigger creates model' do
        result = CreateTrigger.call(shop: @shop, title: title, resource: resource, properties: properties)
        assert result.success?
        assert result.trigger.persisted?
        assert result.trigger.pending?
        assert_equal title, result.trigger.title
        assert_equal resource.flow_name, result.trigger.resource_name
        assert_equal resource.flow_url, result.trigger.resource_url
        assert_equal properties, result.trigger.properties
      end

      test 'call to create flow trigger enqueues processing job' do
        assert_enqueued_with(job: ProcessTriggerJob) do
          CreateTrigger.call(shop: @shop, title: title, resource: resource, properties: properties)
        end
      end

      private

        def title
          'Test trigger'
        end

        def resource
          OpenStruct.new(
            flow_name: 'test_resource_name',
            flow_url: 'https://example.com/test-resource-url'
          )
        end

        def properties
          {
            'Customer email' => 'name@example.com'
          }
        end

    end
  end
end
