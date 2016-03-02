class DiscoApp::ApplicationCharge < ActiveRecord::Base

  belongs_to :shop
  belongs_to :subscription

  enum status: [:pending, :accepted, :declined, :expired, :active]

  scope :active, -> { where status: statuses[:active] }

  def activate_url
    DiscoApp::Engine.routes.url_helpers.activate_subscription_charge_url(subscription, self)
  end

end
