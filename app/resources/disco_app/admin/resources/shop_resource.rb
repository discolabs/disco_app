require 'jsonapi/resource'

class DiscoApp::Admin::Resources::ShopResource < JSONAPI::Resource

  attributes :shopify_domain, :status, :email, :country_name
  attributes :currency, :domain, :plan_display_name, :created_at
  attributes :installed_duration

  model_name 'DiscoApp::Shop'

  filters :status

  # Adjust the base records method to ensure only models for the authenticated domain are retrieved.
  def self.records(options = {})
    records = DiscoApp::Shop.order(created_at: :desc)
    records
  end

  # Apply filters.
  def self.apply_filter(records, filter, value, options)
    return records if value.blank?

    # Perform appropriate filtering.
    case filter
      when :status
        puts value
        return records.where(status: value.map { |v| DiscoApp::Shop.statuses[v.to_sym] } )
      else
        return super(records, filter, value)
    end
  end

  # Don't allow the update of any fields via the API.
  def self.updatable_fields(context)
    []
  end

  # Don't allow the creation of any fields via the API.
  def self.creatable_fields(context)
    []
  end
end
