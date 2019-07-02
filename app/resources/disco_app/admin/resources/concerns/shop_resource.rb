require 'jsonapi/resource'

module DiscoApp::Admin::Resources::Concerns::ShopResource

  extend ActiveSupport::Concern

  included do
    attributes :domain, :status, :created_at
    attributes :email, :country_name, :currency, :plan_display_name
    attributes :current_subscription_id, :current_subscription_display_amount, :current_subscription_display_plan, :current_subscription_display_plan_code, :current_subscription_source
    attributes :installed_duration

    model_name 'DiscoApp::Shop'

    filters :query, :status

    # Adjust the base records method to ensure only models for the authenticated domain are retrieved.
    def self.records(_options = {})
      records = DiscoApp::Shop.order(created_at: :desc)
      records
    end

    # Apply filters.
    def self.apply_filter(records, filter, value, _options)
      return records if value.blank?

      # Perform appropriate filtering.
      case filter
      when :query
        return records.where('name LIKE ? OR shopify_domain LIKE ? OR domain LIKE ?', "%#{value.first}%", "%#{value.first}%", "%#{value.first}%")
      when :status
        return records.where(status: value.map { |v| DiscoApp::Shop.statuses[v.to_sym] })
      else
        return super(records, filter, value)
      end
    end

    # Don't allow the update of any fields via the API.
    def self.updatable_fields(_context)
      []
    end

    # Don't allow the creation of any fields via the API.
    def self.creatable_fields(_context)
      []
    end

    def email
      @model.data[:email]
    end

    def country_name
      @model.data[:country_name]
    end

    def currency
      @model.data[:currency]
    end

    def plan_display_name
      @model.data[:plan_display_name]
    end

    def current_subscription_id
      @model.current_subscription.id if @model.current_subscription?
    end

    def current_subscription_display_amount
      if @model.current_subscription?
        @model.current_subscription.amount
      else
        '-'
      end
    end

    def current_subscription_display_plan
      if @model.current_subscription?
        @model.current_plan.name
      else
        'None'
      end
    end

    def current_subscription_display_plan_code
      @model.current_subscription&.plan_code&.code
    end

    def current_subscription_source
      if @model.current_subscription?
        @model.current_subscription.source || '-'
      else
        '-'
      end
    end
  end

end
