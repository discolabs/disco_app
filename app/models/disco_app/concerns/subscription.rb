module DiscoApp::Concerns::Subscription
  extend ActiveSupport::Concern

  included do

    belongs_to :shop
    belongs_to :plan

    has_many :one_time_charges, class_name: 'DiscoApp::ApplicationCharge', dependent: :destroy
    has_many :recurring_charges, class_name: 'DiscoApp::RecurringApplicationCharge', dependent: :destroy

    enum status: [:trial, :active, :cancelled]
    enum subscription_type: [:recurring, :one_time]

    scope :current, -> { where status: [statuses[:trial], statuses[:active]] }

  end

  # Only require an active charge if the amount to be charged is > 0.
  def requires_active_charge?
    plan.amount > 0
  end

  # Convenience method to check if this subscription has an active charge.
  def active_charge?
    active_charge.present?
  end

  # Convenience method to get the active charge for this subscription.
  def active_charge
    charges.active.first
  end

  # Return the appropriate set of charges for this subscription's type.
  def charges
    recurring? ? recurring_charges : one_time_charges
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
