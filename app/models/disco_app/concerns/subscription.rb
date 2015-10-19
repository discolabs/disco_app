module DiscoApp::Concerns::Subscription
  extend ActiveSupport::Concern

  included do

    belongs_to :shop
    belongs_to :plan

    enum status: [:active, :replaced, :cancelled]

    scope :active, -> { where status: statuses[:active] }

  end
end
