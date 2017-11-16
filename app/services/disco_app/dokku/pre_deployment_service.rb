module DiscoApp
  module Dokku
    class PreDeploymentService < BaseService

      ENV_FILE = '.env'

      # Ensure SHOPIFY_APP_SCOPE are up-to-date
      def update_shopify_scopes
        scopes = nil
        File.foreach(ENV_FILE) do |line|
          if line.include?('SHOPIFY_APP_SCOPE')
            scopes = line.split('=').second
          end
        end

        if scopes.present?
          ShopifyApp.configure { |config| config.scope = scopes }
          dokkuish_message('Scopes updated from .env file')
        end
      end

    end
  end
end
