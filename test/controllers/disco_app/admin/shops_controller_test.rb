require 'test_helper'

class DiscoApp::Admin::ShopsControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    ENV['ADMIN_APP_USERNAME'] = 'admin_app_username'
    ENV['ADMIN_APP_PASSWORD'] = 'admin_app_password'
    @routes = DiscoApp::Engine.routes
  end

  def teardown
    ENV['ADMIN_APP_USERNAME'] = nil
    ENV['ADMIN_APP_PASSWORD'] = nil
  end

  test 'can not access shops list without authorization' do
    get(:index)
    assert_response :unauthorized
  end

  test 'can not access shops list with incorrect username/password' do
    authenticate('fakeuser', 'blah blah')
    get(:index)
    assert_response :unauthorized
  end

  test 'can not access shops list with blank username/password' do
    authenticate('', '')
    get(:index)
    assert_response :unauthorized
  end

  test 'can not access shops list with blank username/password when env variables are blank' do
    ENV['ADMIN_APP_USERNAME'] = ''
    ENV['ADMIN_APP_PASSWORD'] = ''
    authenticate('', '')
    get(:index)
    assert_response :unauthorized
  end

  test 'can access shops list with correct username/password' do
    authenticate('admin_app_username', 'admin_app_password')
    get(:index)
    assert_response :ok
  end

  private

    def authenticate(username, password)
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    end

end
