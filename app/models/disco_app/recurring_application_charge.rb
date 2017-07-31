class DiscoApp::RecurringApplicationCharge < ActiveRecord::Base

  belongs_to :shop
  belongs_to :subscription

  enum status: {
    pending: 0,
    accepted: 1,
    declined: 2,
    active: 3,
    cancelled: 4,
    expired: 5
  }

  scope :active, -> { where status: statuses[:active] }

  def recurring?
    true
  end

  def activate_url
    DiscoApp::Engine.routes.url_helpers.activate_subscription_charge_url(subscription, self)
  end

end
