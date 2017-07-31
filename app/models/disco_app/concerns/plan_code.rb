module DiscoApp::Concerns::PlanCode
  extend ActiveSupport::Concern

  included do

    belongs_to :plan

    enum status: {
      available: 0,
      unavailable: 1
    }

    validates_presence_of :code
    validates_presence_of :amount

  end

end
