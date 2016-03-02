module DiscoApp::Concerns::Subscription
  extend ActiveSupport::Concern

  included do

    belongs_to :shop
    belongs_to :plan

    has_many :charges, class_name: 'DiscoApp::ApplicationCharge'
    has_many :recurring_charges, class_name: 'DiscoApp::RecurringApplicationCharge'

    enum status: [:trial, :active, :cancelled]
    enum subscription_type: [:recurring, :one_time]

    scope :current, -> { where status: [statuses[:trial], statuses[:active]] }

  end

  # Only require an accepted charge if the amount to be charged is > 0.
  def requires_accepted_charge?
    plan.amount > 0
  end

  # Convenience method to check if this subscription has an accepted charge.
  def accepted_charge?
    accepted_charge.present?
  end

  # Convenience method to get the accepted charge for this subscription.
  def accepted_charge
    if recurring?
      recurring_charges.accepted.first
    else
      charges.accepted.first
    end
  end

  def charge_class
    recurring? ? DiscoApp::RecurringApplicationCharge : DiscoApp::ApplicationCharge
  end

  def shopify_charge_class
    recurring? ? ShopifyAPI::RecurringApplicationCharge : ShopifyAPI::ApplicationCharge
  end

  # Return the amount chargeable for this subscription. Currently just passes
  # through the plan's amount value, but in the future this will be usable for
  # per-subscription discounting.
  def amount
    plan.amount
  end

end
