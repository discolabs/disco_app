module DiscoApp
  module Flow
    class Action < ApplicationRecord

      include DiscoApp::Flow::Concerns::Action

    end
  end
end
