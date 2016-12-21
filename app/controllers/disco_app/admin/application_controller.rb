class DiscoApp::Admin::ApplicationController < ActionController::Base
  include DiscoApp::Admin::Concerns::AuthenticatedController

  private

    helper_method :current_shop
    def current_shop
      @current_shop ||= @shop
    end
end
