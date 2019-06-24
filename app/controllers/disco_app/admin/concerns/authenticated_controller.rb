module DiscoApp::Admin::Concerns::AuthenticatedController

  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :exception
    before_action :authenticate_administrator
    layout 'admin'
  end

  private

    def authenticate_administrator
      authenticate_or_request_with_http_basic do |username, password| 
        username.present? && 
        password.present? && 
        username == ENV['ADMIN_APP_USERNAME'] && 
        password == ENV['ADMIN_APP_PASSWORD'] 
      end 
    end

end
