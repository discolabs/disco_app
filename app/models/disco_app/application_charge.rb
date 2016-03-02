class DiscoApp::ApplicationCharge < ActiveRecord::Base

  belongs_to :shop
  belongs_to :subscription

  enum status: [:pending, :accepted, :declined, :expired]

  scope :accepted, -> { where status: statuses[:accepted] }

end
