require 'test_helper'

class DiscoApp::SendSubscriptionJobTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
    stub_request(:post, "https://api.discolabs.com/v1/app_subscriptions.json").to_return(status: 200)
  end

  def teardown
    @shop = nil

    WebMock.reset!
  end

  test 'subscription job correctly sends request to API' do
    perform_enqueued_jobs do
      DiscoApp::SendSubscriptionJob.perform_later(@shop)
    end
    assert_requested(:post, "https://api.discolabs.com/v1/app_subscriptions.json", times: 1)
  end

end
