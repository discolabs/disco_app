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
        result = CreateTrigger.call(shop: @shop, title: title, resource_name: resource_name, resource_url: resource_url, properties: properties)
        assert result.success?
        assert result.trigger.persisted?
        assert result.trigger.pending?
        assert_equal title, result.trigger.title
        assert_equal resource_name, result.trigger.resource_name
        assert_equal resource_url, result.trigger.resource_url
        assert_equal properties, result.trigger.properties
      end

      test 'call to create flow trigger enqueues processing job' do
        assert_enqueued_with(job: ProcessTriggerJob) do
          CreateTrigger.call(shop: @shop, title: title, resource_name: resource_name, resource_url: resource_url, properties: properties)
        end
      end

      private

        def title
          'Test trigger'
        end

        def resource_name
          'test_resource_name'
        end

        def resource_url
          'https://example.com/test-resource-url'
        end

        def properties
          {
            'Customer email' => 'name@example.com'
          }
        end

    end
  end
end
