module DiscoApp
  module Shop
    extend ActiveSupport::Concern

    # Include the base ShopifyApp functionality.
    include ShopifyApp::Shop

    included do
      # Define possible installation statuses as an enum.
      enum status: [:never_installed, :awaiting_install, :installing, :installed, :awaiting_uninstall, :uninstalling, :uninstalled]

      # Define possible charge statuses as an enum.
      enum charge_status: [:charge_none, :charge_pending, :charge_accepted, :charge_declined, :charge_active, :charge_cancelled, :charge_waived]

      # Alias 'with_shopify_session' as 'temp', as per our existing conventions.
      alias_method :temp, :with_shopify_session
    end

    # Return a hash of attributes that should be used to create a new charge for this shop.
    # This method can be overridden by the inheriting Shop class in order to provide charges
    # customised to a particular shop. Otherwise, the default settings configured in application.rb
    # will be used.
    def new_charge_attributes
      {
          type: Rails.configuration.x.shopify_charges_default_type,
          name: Rails.configuration.x.shopify_app_name,
          price: Rails.configuration.x.shopify_charges_default_price,
          trial_days: Rails.configuration.x.shopify_charges_default_trial_days,
      }
    end

    # Update this Shop's charge_status attribute based on the given Shopify charge object.
    def update_charge_status(shopify_charge)
      status_update_method_name = "charge_#{shopify_charge.status}!"
      self.public_send(status_update_method_name) if self.respond_to? status_update_method_name
    end

  end
end
