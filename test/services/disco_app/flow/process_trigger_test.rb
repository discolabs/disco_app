require 'test_helper'

module DiscoApp
  module Flow
    class ProcessTriggerTest < ActiveSupport::TestCase

      include ActiveJob::TestHelper

      def setup
        @shop = disco_app_shops(:widget_store)
        @trigger = @shop.flow_triggers.create(
          title: 'Test trigger',
          resource_name: 'test_resource_name',
          resource_url: 'https://example.com/test-resource-url',
          properties: { 'Customer email' => 'name@example.com' }
        )
        @now = Time.zone.parse('2018-12-29T00:00:00Z')
        Timecop.freeze(@now)
      end

      def teardown
        @shop = nil
        @trigger = nil
        @now = nil
        Timecop.return
      end

      test 'call to process trigger that has already succeeded fails' do
        @trigger.succeeded!
        result = ProcessTrigger.call(trigger: @trigger)
        assert_not result.success?
      end

      test 'call to process trigger that has already failed fails' do
        @trigger.failed!
        result = ProcessTrigger.call(trigger: @trigger)
        assert_not result.success?
      end

      test 'call to process trigger that has already been skipped fails' do
        @trigger.skipped!
        result = ProcessTrigger.call(trigger: @trigger)
        assert_not result.success?
      end

      test 'call to process trigger that we know is not being used succeeds with skipped status logged' do
        @shop.flow_trigger_usages.create(
          flow_trigger_definition_id: @trigger.title,
          has_enabled_flow: false,
          timestamp: @now
        )
        result = ProcessTrigger.call(trigger: @trigger)
        assert result.success?
        assert @trigger.skipped?
        assert_equal @now, @trigger.processed_at
      end

      test 'processing valid pending trigger succeeds and makes the expected api call' do
        VCR.use_cassette('flow_trigger_valid') do
          result = ProcessTrigger.call(trigger: @trigger)
          assert result.success?
          assert @trigger.succeeded?
          assert_equal @now, @trigger.processed_at
        end
      end

      test 'processing valid pending trigger that we know is being used succeeds and makes the expected api call' do
        @shop.flow_trigger_usages.create(
          flow_trigger_definition_id: @trigger.title,
          has_enabled_flow: true,
          timestamp: @now
        )

        VCR.use_cassette('flow_trigger_valid') do
          result = ProcessTrigger.call(trigger: @trigger)
          assert result.success?
          assert @trigger.succeeded?
          assert_equal @now, @trigger.processed_at
        end
      end

      test 'processing invalid pending trigger makes the expected api call with errors logged' do
        VCR.use_cassette('flow_trigger_invalid_title') do
          result = ProcessTrigger.call(trigger: @trigger)
          assert_not result.success?
          assert @trigger.failed?
          assert_equal @now, @trigger.processed_at
          assert_equal 1, @trigger.processing_errors.size
        end
      end

    end
  end
end
