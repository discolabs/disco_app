require 'rest-client'

module DiscoApp

  class DiscoApiError < StandardError; end

  class ApiClient

    SUBSCRIPTION_ENDPOINT = 'app_subscriptions.json'.freeze

    def initialize(shop, url)
      @shop = shop
      @url = url
    end

    def create_app_subscription
      return if @url.blank?

      url = @url + SUBSCRIPTION_ENDPOINT
      begin
        RestClient::Request.execute(
          method: :post,
          headers: { content_type: :json },
          url: url,
          payload: { shop: @shop, subscription: @shop.current_subscription }.to_json
        )
      rescue RestClient::BadRequest, RestClient::ResourceNotFound => e
        raise DiscoApiError, e.message
      end
    end

  end
end
