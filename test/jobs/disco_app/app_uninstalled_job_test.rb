require 'test_helper'

class DiscoApp::AppUninstalledJobTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
    @shop.charge_active!

    perform_enqueued_jobs do
      DiscoApp::AppUninstalledJob.perform_later(@shop.shopify_domain, {})
    end
  end

  def teardown
    @shop = nil
  end

  test 'app uninstalled job changes shop status' do
    assert_performed_jobs 1
    @shop.reload
    assert @shop.uninstalled?
  end

  test 'app uninstalled job can be extended using concerns' do
    assert_performed_jobs 1
    @shop.reload
    assert @shop.charge_cancelled? # Assert base methods still called.
    assert_equal 'Nowhere', @shop.country_name # Assert extended method called.
  end

end
