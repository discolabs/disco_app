module DiscoApp
  module Shop
    extend ActiveSupport::Concern

    # Include the base ShopifyApp functionality.
    include ShopifyApp::Shop

    included do
      # Define possible installation statuses as an enum.
      enum status: [:never_installed, :installing, :installed, :uninstalling, :uninstalled]

      # Alias 'with_shopify_session' as 'temp', as per our existing conventions.
      alias_method :temp, :with_shopify_session

      # Define action hooks.
      after_commit :install_if_token_changed
    end

    protected

      # If the token has changed, then the application has just been installed and the installation job should be queued.
      def install_if_token_changed
        return unless previous_changes.has_key?('shopify_token')
        AppInstalledJob.perform_later(self.shopify_domain)
      end

  end
end