class DiscoApp::ApplicationCharge < ActiveRecord::Base

  belongs_to :shop
  belongs_to :subscription

  enum status: {
    pending: 0,
    accepted: 1,
    declined: 2,
    expired: 3,
    active: 4,
  }

  scope :active, -> { where status: statuses[:active] }

  def recurring?
    false
  end

  def activate_url
    DiscoApp::Engine.routes.url_helpers.activate_subscription_charge_url(subscription, self)
  end

end
