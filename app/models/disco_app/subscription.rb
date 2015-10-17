module DiscoApp
  class Subscription < ActiveRecord::Base

    belongs_to :shop
    belongs_to :plan

    enum status: [:active, :replaced, :cancelled]

  end
end
