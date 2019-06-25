require 'test_helper'

class ApiClientTest < ActiveSupport::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
    stub_request(:post, 'https://api.discolabs.com/v1/app_subscriptions.json')
      .with(body: api_fixture('subscriptions/valid_request').to_json)
      .to_return(status: 200, body: api_fixture('subscriptions/valid_request').to_json)
  end

  def teardown
    @shop = nil
    WebMock.reset!
  end

  test 'Successful disco api call render correct JSON' do
    response = @shop.disco_api_client.create_app_subscription
    assert_equal api_fixture('subscriptions/valid_request'), JSON.parse(response.body)
  end

end
