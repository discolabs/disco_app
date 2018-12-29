require 'rest-client'

module DiscoApp
  class GraphqlClient

    def initialize(shop)
      @shop = shop
    end

    ##
    # Trigger a Shopify Flow trigger.
    # Returns a tuple {Boolean, Array}
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
