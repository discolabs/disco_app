require 'test_helper'

class DiscoApp::AppInstalledJobTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)

    stub_request(:get, "#{@shop.admin_url}/webhooks.json").to_return(status: 200, body: api_fixture('widget_store/webhooks').to_json)
    stub_request(:post, "#{@shop.admin_url}/webhooks.json").to_return(status: 200)
    stub_request(:get, "#{@shop.admin_url}/shop.json").to_return(status: 200, body: api_fixture('widget_store/shop').to_json)
  end

  def teardown
    @shop = nil

    WebMock.reset!
  end

  test 'app installed job performs shop update job' do
    # Assert the main install job can be enqueued and performed.
    perform_enqueued_jobs do
      DiscoApp::AppInstalledJob.perform_later(@shop)
    end

    # Assert the update shop job was performed.
    @shop.reload
    assert_equal 'United States', @shop.data['country_name']
  end

  test 'app installed job automatically subscribes stores to the correct default plan' do
    @shop.current_subscription.destroy

    perform_enqueued_jobs do
      DiscoApp::AppInstalledJob.perform_later(@shop)
    end

    # Assert the shop was subscribed to the development plan.
    assert_equal disco_app_plans(:development), @shop.current_subscription.plan
  end

  test 'app installed job automatically subscribes stores to the correct default plan with a plan code and a source' do
    @shop.current_subscription.destroy

    perform_enqueued_jobs do
      DiscoApp::AppInstalledJob.perform_later(@shop, 'PODCAST', 'smpodcast')
    end

    # Assert the shop was subscribed to the development plan.
    assert_equal disco_app_plans(:development), @shop.current_subscription.plan
    assert_equal disco_app_plan_codes(:podcast_dev), @shop.current_subscription.plan_code
    assert_equal 'smpodcast', @shop.current_subscription.source
  end

end
