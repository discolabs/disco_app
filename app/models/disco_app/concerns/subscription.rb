module DiscoApp::Concerns::Subscription

  extend ActiveSupport::Concern

  included do
    belongs_to :shop
    belongs_to :plan
    belongs_to :plan_code, optional: true
    belongs_to :source, optional: true
    has_many :one_time_charges, class_name: 'DiscoApp::ApplicationCharge', dependent: :destroy
    has_many :recurring_charges, class_name: 'DiscoApp::RecurringApplicationCharge', dependent: :destroy

    enum status: {
      trial: 0,
      active: 1,
      cancelled: 2
    }
    enum subscription_type: {
      recurring: 0,
      one_time: 1
    }

    scope :current, -> { where status: [statuses[:trial], statuses[:active]] }

    after_commit :cancel_charge
  end

  # Only require an active charge if the amount to be charged is > 0.
  def requires_active_charge?
    amount > 0
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

  def as_json(options = {})
    super.merge(
      'active_charge' => active_charge
    )
  end

  private

    # If the amount or trial period for this subscription changes, clear any
    # active charge, as the user will need to re-authorize the charge.
    def cancel_charge
      return if (previous_changes.keys & ['amount', 'trial_period_days']).empty?
      return unless active_charge?

      active_charge.cancelled!
    end

end
