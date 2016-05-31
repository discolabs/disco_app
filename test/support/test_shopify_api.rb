module DiscoApp::Test
  module ShopifyAPI

    def stub_api_request(method, endpoint, fixture_name)
      if method == :get
        stub_request(method, endpoint)
          .to_return(status: 200, body: api_fixture("#{fixture_name}_response").to_json)
      elsif method == :post or method == :put
        stub_request(method, endpoint)
          .with(body: api_fixture("#{fixture_name}_request").to_json)
          .to_return(status: 201, body: api_fixture("#{fixture_name}_response").to_json)
      end
    end

  end
end
