require 'test_helper'

class DiscoApp::SynchroniseUsersJobTest < ActionController::TestCase
  include ActiveJob::TestHelper

  def setup
    @shop = disco_app_shops(:widget_store)
    stub_request(:get, "#{@shop.admin_url}/users.json").to_return(status: 200, body: api_fixture('widget_store/users').to_json)
  end

  def teardown
    @shop = nil
    WebMock.reset!
  end

  test 'Successfully synchronise users via background job' do
    perform_enqueued_jobs do
      DiscoApp::SynchroniseUsersJob.perform_later(@shop)
    end
    user = DiscoApp::User.first
    assert_equal 'Steve', user.first_name
    assert_equal 'Jobs', user.last_name
    assert_equal 'steve@apple.com', user.email
  end

end
