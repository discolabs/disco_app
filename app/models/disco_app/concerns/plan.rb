module DiscoApp::Concerns::Plan
  extend ActiveSupport::Concern

  included do

    has_many :subscriptions
    has_many :shops, through: :subscriptions
    has_many :plan_codes, dependent: :destroy

    accepts_nested_attributes_for :plan_codes, allow_destroy: true

    enum status: [:available, :unavailable]
    enum plan_type: [:recurring, :one_time]
    enum interval: [:month, :year]

    scope :available, -> { where status: statuses[:available] }

    validates_presence_of :name

  end

  def has_trial?
    trial_period_days.present? and trial_period_days > 0
  end

end
