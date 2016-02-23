module DiscoApp
  class Admin::ApplicationController < ActionController::Base
    include DiscoApp::Admin::AuthenticatedController

    layout 'admin'
  end
end
