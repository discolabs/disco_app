module DiscoApp::Concerns::Shop

  extend ActiveSupport::Concern

  included do
    include ShopifyApp::SessionStorage
    include ActionView::Helpers::DateHelper

    # Define relationships to plans and subscriptions.
    has_many :subscriptions, dependent: :restrict_with_exception
    has_many :plans, through: :subscriptions

    # Define relationship to users.
    has_many :users, dependent: :restrict_with_exception

    # Define relationship to sessions.
    has_many :sessions, class_name: 'DiscoApp::Session', dependent: :destroy

    # Define relationship to Flow actions and triggers.
    has_many :flow_actions, class_name: 'DiscoApp::Flow::Action', dependent: :destroy
    has_many :flow_triggers, class_name: 'DiscoApp::Flow::Trigger', dependent: :destroy
    has_many :flow_trigger_usages, class_name: 'DiscoApp::Flow::TriggerUsage', dependent: :destroy

    # Define possible installation statuses as an enum.
    enum status: {
      never_installed: 0,
      awaiting_install: 1,
      installing: 2,
      installed: 3,
      awaiting_uninstall: 4,
      uninstalling: 5,
      uninstalled: 6
    }

    # Define some useful scopes.
    scope :status, ->(status) { where status: status }
    scope :installed, -> { where status: statuses[:installed] }
    scope :has_active_shopify_plan, -> { where.not(plan_name: [:cancelled, :frozen, :fraudulent]) }
    scope :shopify_plus, -> { where(plan_name: :shopify_plus) }

    # Alias 'with_shopify_session' as 'with_api_context' for better readability, but also as 'temp' for
    # backward compatibility.
    alias_method :with_api_context, :with_shopify_session
    alias_method :temp, :with_shopify_session

    # Return true if the shop is considered as in development mode.
    def development?
      ['staff', 'affiliate'].include?(plan_name)
    end

    # Convenience method to check if this shop has a current subscription.
    def current_subscription?
      current_subscription.present?
    end

    # Convenience method to get the current subscription for this shop, if any.
    def current_subscription
      subscriptions.current.first
    end

    # Convenience method to get the current plan for this shop, if any.
    def current_plan
      current_subscription&.plan
    end

    # Return the absolute URL to the shop's storefront.
    def url
      "#{protocol}://#{domain}"
    end

    # Return the protocol the shop's storefront uses. This should now always be
    # https as all Shopify stores have SSL enabled.
    def protocol
      'https'
    end

    # Return the absolute URL to the shop's admin.
    def admin_url
      "https://#{shopify_domain}/admin/api/#{api_version}"
    end

    # Return the absolutely URL to the shop's admin.
    def shopify_url
      "https://#{shopify_domain}"
    end

    def installed_duration
      distance_of_time_in_words_to_now(created_at.time)
    end

    # Return the shop's configured timezone. If none can be parsed from the
    # shop's "data" hash, return the default Rails zone (which should be UTC).
    def time_zone
      @time_zone ||= Time.find_zone!(data[:iana_timezone]) || Time.zone
    end

    # Return the shop's configured locale as a symbol. If none exists for some
    # reason, 'en' is returned.
    def locale
      (data[:primary_locale] || 'en').to_sym
    end

    # Return an instance of the Disco API client.
    def disco_api_client
      @disco_api_client ||= DiscoApp::ApiClient.new(self, ENV['DISCO_API_URL'])
    end

    # Override the "read" data attribute to allow indifferent access.
    def data
      read_attribute(:data).with_indifferent_access
    end

    def api_version
      ShopifyApp.configuration.api_version
    end

  end

end
