module DiscoApp
  class Plan < ActiveRecord::Base

    has_many :subscriptions
    has_many :shops, through: :subscriptions

    enum status: [:available, :unavailable, :hidden]

  end
end
