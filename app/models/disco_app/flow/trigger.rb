module DiscoApp
  module Flow
    class Trigger < ApplicationRecord
      include DiscoApp::Flow::Concerns::Trigger
    end
  end
end
