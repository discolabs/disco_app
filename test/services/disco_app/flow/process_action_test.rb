require 'test_helper'

module DiscoApp
  module Flow
    class ProcessActionTest < ActiveSupport::TestCase

      include ActiveJob::TestHelper

      def setup
        @shop = disco_app_shops(:widget_store)
        @action = @shop.flow_actions.create(
          action_id: 'test_action_id',
          action_run_id: 'bdb15e45-4f9d-4c80-88c8-7b43a24edaac-30892-cc8eb62a-14db-43fc-bc33-d6dea41ae623',
          properties: { 'customer_email' => 'name@example.com' }
        )
        @now = Time.parse('2018-12-29T00:00:00Z')
        Timecop.freeze(@now)
      end

      def teardown
        @shop = nil
        @action = nil
        @now = nil
        Timecop.return
      end

      test 'call to process action that has already succeeded fails' do
        @action.succeeded!
        result = ProcessAction.call(action: @action)
        assert_not result.success?
      end

      test 'call to process trigger that has already failed fails' do
        @action.failed!
        result = ProcessAction.call(action: @action)
        assert_not result.success?
      end

    end
  end
end
