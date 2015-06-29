module DiscoApp
  module Shop
    extend ActiveSupport::Concern

    # Include the base ShopifyApp functionality.
    include ShopifyApp::Shop

    included do
      # Define possible installation statuses as an enum.
      enum status: [:never_installed, :installing, :installed, :uninstalling, :uninstalled]

      # Define possible charge statuses as an enum.
      enum charge_status: [:charge_none, :charge_pending, :charge_accepted, :charge_declined, :charge_activated, :charge_cancelled, :charge_waived]

      # Alias 'with_shopify_session' as 'temp', as per our existing conventions.
      alias_method :temp, :with_shopify_session
    end

  end
end