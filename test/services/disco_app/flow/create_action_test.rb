require 'test_helper'

module DiscoApp
  module Flow
    class CreateActionTest < ActiveSupport::TestCase

      include ActiveJob::TestHelper

      def setup
        @shop = disco_app_shops(:widget_store)
      end

      def teardown
        @shop = nil
      end

      test 'call to create flow action creates model' do
        result = CreateAction.call(shop: @shop, action_id: action_id, action_run_id: action_run_id, properties: properties)
        assert result.success?
        assert result.action.persisted?
        assert result.action.pending?
        assert_equal action_id, result.action.action_id
        assert_equal action_run_id, result.action.action_run_id
        assert_equal properties, result.action.properties
      end

      test 'call to create flow action enqueues processing job' do
        assert_enqueued_with(job: ProcessActionJob) do
          CreateAction.call(shop: @shop, action_id: action_id, action_run_id: action_run_id, properties: properties)
        end
      end

      private

        def action_id
          'test_action_id'
        end

        def action_run_id
          'bdb15e45-4f9d-4c80-88c8-7b43a24edaac-30892-cc8eb62a-14db-43fc-bc33-d6dea41ae623'
        end

        def properties
          {
            'customer_email' => 'name@example.com'
          }
        end

    end
  end
end
