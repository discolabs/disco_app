module DiscoApp
  module  Concerns
    module  CustomersRedactJob

      extend ActiveSupport::Concern

      def perform(_shop, redaction_request)
        # See https://shopify.dev/tutorials/add-gdpr-webhooks-to-your-app#customers-redact
      end

    end
  end
end
