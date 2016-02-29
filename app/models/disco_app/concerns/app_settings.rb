module DiscoApp::Concerns::AppSettings
  extend ActiveSupport::Concern

  included do
    acts_as_singleton
  end
end
