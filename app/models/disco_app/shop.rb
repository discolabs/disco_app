module DiscoApp
  module Shop
    extend ActiveSupport::Concern

    # Include the base ShopifyApp functionality.
    include ShopifyApp::Shop

    # Define possible installation statuses as an enum.
    enum status: [:never_installed, :installing, :installed, :uninstalling, :uninstalled]

    # Alias 'with_shopify_session' as 'temp', as per our existing conventions.
    alias_method :temp, :with_shopify_session

  end
end