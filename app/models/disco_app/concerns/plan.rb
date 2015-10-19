module DiscoApp::Concerns::Plan
  extend ActiveSupport::Concern

  included do

    has_many :subscriptions
    has_many :shops, through: :subscriptions

    enum status: [:available, :unavailable, :hidden]

    scope :available, -> { where status: statuses[:available] }

  end
end
