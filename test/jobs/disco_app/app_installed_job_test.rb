require 'test_helper'

class DiscoApp::AppInstalledJobTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
  end

  def teardown
    @shop = nil
  end

  test 'app installed job performs shop update job' do
    stub_request(:get, "#{@shop.admin_url}/webhooks.json").to_return(status: 200, body: api_fixture('widget_store/webhooks').to_json)
    stub_request(:post, "#{@shop.admin_url}/webhooks.json").to_return(status: 200)
    stub_request(:get, "#{@shop.admin_url}/shop.json").to_return(status: 200, body: api_fixture('widget_store/shop').to_json)

    # Assert the main install job can be enqueued and performed.
    perform_enqueued_jobs do
      DiscoApp::AppInstalledJob.perform_later(@shop.shopify_domain)
    end
    assert_performed_jobs 1

    # Assert the update shop job was performed.
    @shop.reload
    assert_equal 'United States', @shop.country_name
  end

end
