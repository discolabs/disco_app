require 'test_helper'

class DiscoApp::SynchroniseCarrierServiceJobTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)

    stub_request(:get, "#{@shop.admin_url}/carrier_services.json").to_return(status: 200, body: api_fixture('widget_store/carrier_services').to_json)
    stub_request(:post, "#{@shop.admin_url}/carrier_services.json").with(body: api_fixture('widget_store/carrier_services_create').to_json).to_return(status: 200)
  end

  def teardown
    @shop = nil

    WebMock.reset!
  end

  test 'carrier service synchronisation job creates expected carrier service' do
    perform_enqueued_jobs do
      DiscoApp::SynchroniseCarrierServiceJob.perform_later(@shop)
    end
  end

end
