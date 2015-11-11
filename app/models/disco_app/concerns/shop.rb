module DiscoApp::Concerns::Shop
  extend ActiveSupport::Concern

  included do
    include ShopifyApp::Shop

    # Define relationships to plans and subscriptions.
    has_many :subscriptions
    has_many :plans, through: :subscriptions

    # Define possible installation statuses as an enum.
    enum status: [:never_installed, :awaiting_install, :installing, :installed, :awaiting_uninstall, :uninstalling, :uninstalled]

    # Define possible charge statuses as an enum.
    enum charge_status: [:charge_none, :charge_pending, :charge_accepted, :charge_declined, :charge_active, :charge_cancelled, :charge_waived]

    # Define some useful scopes.
    scope :status, -> (status) { where status: status }
    scope :installed, -> { where status: statuses[:installed] }
    scope :has_active_shopify_plan, -> { where.not(plan_name: [:cancelled, :frozen, :fraudulent]) }

    # Alias 'with_shopify_session' as 'temp', as per our existing conventions.
    alias_method :temp, :with_shopify_session

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

    # Convenience method to get the currently active subscription for this Shop.
    def current_subscription
      subscriptions.active.first
    end

    # Return the absolute URL to the shop's storefront.
    # @TODO: Account for HTTPS.
    def url
      "http://#{domain}"
    end

    # Return the absolute URL to the shop's admin.
    def admin_url
      "https://#{shopify_domain}/admin"
    end

  end

end
