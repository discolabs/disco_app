class DiscoApp::Admin::ApplicationController < ActionController::Base
  include DiscoApp::Admin::Concerns::AuthenticatedController
end
