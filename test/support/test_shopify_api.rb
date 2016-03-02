module DiscoApp::Test
  module ShopifyAPI

    def stub_api_request(method, endpoint, fixture_name)
      return_status = method == :post ? 201 : 200
      stub_request(method, endpoint)
        .with(body: api_fixture("#{fixture_name}_request").to_json)
        .to_return(status: return_status, body: api_fixture("#{fixture_name}_response").to_json)
    end

  end
end
