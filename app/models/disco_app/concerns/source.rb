module DiscoApp::Concerns::Source

  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :restrict_with_exception
    has_many :shops, through: :subscriptions

    validates_presence_of :source
    validates_presence_of :name
  end

end
