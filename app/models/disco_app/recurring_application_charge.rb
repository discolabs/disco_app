class DiscoApp::RecurringApplicationCharge < ActiveRecord::Base

  belongs_to :shop
  belongs_to :subscription

  enum status: [:pending, :accepted, :declined, :expired, :cancelled]

  scope :accepted, -> { where status: statuses[:accepted] }

  def activate_url
    DiscoApp::Engine.routes.url_helpers.activate_subscription_charge_url(subscription, self)
  end

end
