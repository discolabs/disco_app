require 'test_helper'

module DiscoApp
  module Flow
    class UpdateTriggerUsageTest < ActiveSupport::TestCase

      include ActiveJob::TestHelper

      def setup
        @shop = disco_app_shops(:widget_store)
      end

      def teardown
        @shop = nil
      end

      test 'when no usage record exists and usage is true, record is persisted as expected' do
        result = UpdateTriggerUsage.call(
          shop: @shop,
          flow_trigger_definition_id: flow_trigger_definition_id,
          has_enabled_flow: true,
          timestamp: timestamp
        )

        assert result.success?
        assert result.trigger_usage.persisted?
        assert result.trigger_usage.has_enabled_flow?
        assert_equal timestamp, result.trigger_usage.timestamp
      end

      test 'when usage record exists and timestamp is older, record is updated as expected' do
        older_timestamp = timestamp - 7.days

        trigger_usage = @shop.flow_trigger_usages.create!(
          flow_trigger_definition_id: flow_trigger_definition_id,
          has_enabled_flow: true,
          timestamp: older_timestamp
        )

        result = UpdateTriggerUsage.call(
          shop: @shop,
          flow_trigger_definition_id: flow_trigger_definition_id,
          has_enabled_flow: false,
          timestamp: timestamp
        )

        assert result.success?
        assert_equal trigger_usage, result.trigger_usage
        assert_not result.trigger_usage.has_enabled_flow?
        assert_equal timestamp, result.trigger_usage.timestamp
      end

      test 'when usage record exists and timestamp is newer, record is not updated' do
        newer_timestamp = timestamp + 7.days

        trigger_usage = @shop.flow_trigger_usages.create!(
          flow_trigger_definition_id: flow_trigger_definition_id,
          has_enabled_flow: true,
          timestamp: newer_timestamp
        )

        result = UpdateTriggerUsage.call(
          shop: @shop,
          flow_trigger_definition_id: flow_trigger_definition_id,
          has_enabled_flow: false,
          timestamp: timestamp
        )

        assert result.success?
        assert_equal trigger_usage, result.trigger_usage
        assert result.trigger_usage.has_enabled_flow?
        assert_equal newer_timestamp, result.trigger_usage.timestamp
      end

      private

        def flow_trigger_definition_id
          'Test trigger'
        end

        def timestamp
          @timestamp ||= Time.parse('2020-04-05T00:34:00Z')
        end

    end
  end
end
