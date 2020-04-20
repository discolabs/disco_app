module DiscoApp
  module  Concerns
    module  CustomersDataRequestJob

      extend ActiveSupport::Concern

      def perform(_shop, data_request_data)
        # See https://shopify.dev/tutorials/add-gdpr-webhooks-to-your-app#customers-data_request
      end

    end
  end
end
