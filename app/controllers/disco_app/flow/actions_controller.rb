module DiscoApp
  module Flow
    class ActionsController < ActionController::Base
      include DiscoApp::Flow::Concerns::ActionsController
    end
  end
end
