require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  def setup
    @shop = shops(:widget_store)
    log_in_as(@shop)
  end

  def teardown
    @shop = nil
  end

  test 'non-logged in user is redirected to the login page' do
    log_out
    get(:index)
    assert_redirected_to ShopifyApp::Engine.routes.url_helpers.login_path
  end

  test 'logged-in, never installed user is redirected to the install page' do
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.install_path
  end

  test 'logged-in, awaiting install user is redirected to the installing page' do
    @shop.awaiting_install!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.installing_path
  end

  test 'logged-in, installing user is redirected to the installing page' do
    @shop.installing!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.installing_path
  end

  test 'logged-in, installed user is able to access the page' do
    @shop.installed!
    get(:index)
    assert_response :success
  end

  test 'logged-in, awaiting uninstall user is redirected to the uninstalling page' do
    @shop.awaiting_uninstall!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.uninstalling_path
  end

  test 'logged-in, uninstalling user is redirected to the uninstalling page' do
    @shop.uninstalling!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.uninstalling_path
  end

  test 'logged-in, uninstalled user is redirected to the install page' do
    @shop.uninstalled!
    get(:index)
    assert_redirected_to DiscoApp::Engine.routes.url_helpers.install_path
  end

end
