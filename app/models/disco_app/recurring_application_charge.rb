class DiscoApp::RecurringApplicationCharge < ActiveRecord::Base

  belongs_to :shop
  belongs_to :subscription

  enum status: [:pending, :accepted, :declined, :expired, :cancelled]

  scope :accepted, -> { where status: statuses[:accepted] }

end
