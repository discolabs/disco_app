module DiscoApp::Concerns::Subscription
  extend ActiveSupport::Concern

  included do

    belongs_to :shop
    belongs_to :plan

    enum status: [:trial, :active, :cancelled]
    enum subscription_type: [:recurring, :one_time]

    scope :trial, -> { where status: statuses[:trial] }
    scope :active, -> { where status: statuses[:active] }

  end
end
