require 'rest-client'

##
# This file defines a very simple GraphQL API client to support a single type
# of GraphQL API call for a Shopify store - sending a Shopify Flow trigger.
#
# We use this simple approach rather than using an existing GraphQL client
# library such as https://github.com/github/graphql-client (either standalone
# or as bundled with the Shopify API gem) for a couple of reasons:
#
#   - These libraries tend to presume that a single client instance is
#     instantiated once and then reused across the application, which isn't the
#     case when we're making API calls once per trigger for each background
#     job.
#   - These libraries make an API call to fetch the Shopify GraphQL schema on
#     initialisation. The schema is very large, so the API call takes a number
#     of seconds to complete and when parsed consumes a large amount of memory.
#   - These libraries do not natively work well with the idea of a dynamic API
#     endpoint (ie, changing the request URL frequently), which is required
#     when making many requests to different Shopify stores.
#
module DiscoApp
  class GraphqlClient

    def initialize(shop)
      @shop = shop
    end

    ##
    # Fire a Shopify Flow Trigger.
    # Returns a tuple {Boolean, Array} representing {success, errors}.
    def create_flow_trigger(title, resource_name, resource_url, properties)
      body = {
        trigger_title: title,
        resources: [
          {
            name: resource_name,
            url: resource_url
          }
        ],
        properties: properties
      }

      response = execute(%Q(
        mutation {
          flowTriggerReceive(body: #{body.to_json.to_json}) {
            userErrors {
              field,
              message
            }
          }
        }
      ))

      errors = response.dig(:data, :flowTriggerReceive, :userErrors)
      [errors.empty?, errors]
    end

    private

      def execute(query)
        response = RestClient::Request.execute(
          method: :post,
          headers: headers,
          url: url,
          payload: { query: query }.to_json
        )
        JSON.parse(response.body).with_indifferent_access
      end

      def headers
        {
          'Content-Type' => 'application/json',
          'X-Shopify-Access-Token' => @shop.shopify_token
        }
      end

      def url
        "https://#{@shop.shopify_domain}/admin/api/graphql.json"
      end

  end
end
