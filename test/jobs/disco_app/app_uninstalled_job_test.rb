require 'test_helper'

class DiscoApp::AppUninstalledJobTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
  end

  def teardown
    @shop = nil
  end

  test 'app uninstalled job changes shop status' do
    # Assert the main uninstall job can be enqueued and performed.
    perform_enqueued_jobs do
      DiscoApp::AppUninstalledJob.perform_later(@shop.shopify_domain, {})
    end
    assert_performed_jobs 1

    # Assert the update shop job was performed.
    @shop.reload
    assert @shop.uninstalled?
  end

end
