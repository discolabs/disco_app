require 'test_helper'

class DiscoApp::SynchroniseWebhooksJobTest < ActionController::TestCase

  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
  end

  def teardown
    @shop = nil
    WebMock.reset!
  end

  test 'webhook synchronisation job creates webhooks for all expected topics' do
    with_suppressed_output do
      stub_request(:get, "#{@shop.admin_url}/webhooks.json").to_return(status: 200, body: api_fixture('widget_store/empty_webhooks').to_json)
      stub_request(:post, "#{@shop.admin_url}/webhooks.json").to_return(status: 200)

      perform_enqueued_jobs do
        DiscoApp::SynchroniseWebhooksJob.perform_later(@shop)
      end

      # Assert that all 3 webhook topics without field lists were POSTed to.
      ['app/uninstalled', 'shop/update', 'orders/create'].each do |expected_webhook_topic|
        assert_requested(:post, "#{@shop.admin_url}/webhooks.json", times: 1) do |request|
          request.body.include?(%Q("topic":"#{expected_webhook_topic}")) && request.body.include?('"fields":[]')
        end
      end

      # Assert that the orders/paid webhook topic was posted to with a field restriction.
      assert_requested(:post, "#{@shop.admin_url}/webhooks.json", times: 1) do |request|
        request.body.include?('"topic":"orders/paid"') && request.body.include?('"fields":["id"]')
      end
    end
  end

  test 'webhook synchronisation job only creates and updates webhooks when required' do
    with_suppressed_output do
      stub_request(:get, "#{@shop.admin_url}/webhooks.json").to_return(status: 200, body: api_fixture('widget_store/existing_webhooks').to_json)
      stub_request(:put, "#{@shop.admin_url}/webhooks/748073353266.json").to_return(status: 200)
      stub_request(:put, "#{@shop.admin_url}/webhooks/748073353267.json").to_return(status: 200)
      stub_request(:post, "#{@shop.admin_url}/webhooks.json").to_return(status: 200)

      perform_enqueued_jobs do
        DiscoApp::SynchroniseWebhooksJob.perform_later(@shop)
      end

      # Assert that a missing webhook was created.
      assert_requested(:post, "#{@shop.admin_url}/webhooks.json", times: 1) do |request|
        request.body.include?('"topic":"app/uninstalled"')
      end

      # Assert that no request was made to update an existing webhook with the expected values.
      assert_requested(:post, "#{@shop.admin_url}/webhooks.json", times: 0) do |request|
        request.body.include?('"topic":"shop/update"')
      end

      # Assert that a request was made to update the URL of a webhook with an out of date URL.
      assert_requested(:put, "#{@shop.admin_url}/webhooks/748073353266.json", times: 1) do |request|
        request.body.include?('"topic":"orders/create"') && request.body.include?('"address":"https://test.example.com/webhooks"')
      end

      # Assert that a request was made to update the fields of a webhook with out of date fields.
      assert_requested(:put, "#{@shop.admin_url}/webhooks/748073353267.json", times: 1) do |request|
        request.body.include?('"topic":"orders/paid"') && request.body.include?('"fields":["id"]')
      end
    end
  end

  test 'returns error messages for webhooks that cannot be registered' do
    VCR.use_cassette('webhook_failure') do
      with_suppressed_output do
        output = capture_io do
          perform_enqueued_jobs do
            DiscoApp::SynchroniseWebhooksJob.perform_later(@shop)
          end
        end

        assert output.first.include?('Invalid topic specified.')
        assert output.first.include?('orders/create - not registered')
      end
    end
  end

  private

    # Prevents the output from the webhook synchronisation from
    # printing to STDOUT and messing up the test output
    def with_suppressed_output
      original_stdout = $stdout.clone
      $stdout.reopen(File.new('/dev/null', 'w'))
      yield
    ensure
      $stdout.reopen(original_stdout)
    end

end
