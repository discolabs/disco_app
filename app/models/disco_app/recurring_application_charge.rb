class DiscoApp::RecurringApplicationCharge < ActiveRecord::Base

  belongs_to :shop
  belongs_to :subscription

  enum status: [:pending, :accepted, :declined, :expired, :cancelled, :active]

  scope :active, -> { where status: statuses[:active] }

  def recurring?
    true
  end

  def activate_url
    DiscoApp::Engine.routes.url_helpers.activate_subscription_charge_url(subscription, self)
  end

end
