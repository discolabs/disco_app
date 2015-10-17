require 'test_helper'

class DiscoApp::InstallControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = shops(:widget_store)
    @routes = DiscoApp::Engine.routes
    log_in_as(@shop)
  end

  def teardown
    @shop = nil
  end

  test 'logged-in but uninstalled user triggers installation from install page' do
    get(:install)
    assert_redirected_to :installing
    assert_enqueued_jobs 1
    @shop.reload
    assert @shop.awaiting_install?
  end

end
