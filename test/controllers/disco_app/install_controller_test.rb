require 'test_helper'

class DiscoApp::InstallControllerTest < ActionController::TestCase

  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
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

  test 'logged-in and installed user is redirected to installing url for install/uninstalling actions' do
    @shop.installed!
    [:install, :uninstalling].each do |_action|
      get(:install)
      assert_redirected_to :installing
    end
  end

  test 'logged-in and installed user is redirected to root url for installing' do
    @shop.installed!
    get(:installing)
    assert_redirected_to Rails.application.routes.url_helpers.root_path
  end

  test 'logged-in and uninstalling user sees uninstalling page' do
    @shop.uninstalling!
    get(:uninstalling)
    assert_response :success
  end

  test 'logged-in and uninstalled user starts install process again' do
    @shop.uninstalled!
    get(:uninstalling)
    assert_redirected_to :install
  end

end
