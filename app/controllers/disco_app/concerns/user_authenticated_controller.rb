module DiscoApp::Concerns::UserAuthenticatedController
  extend ActiveSupport::Concern

  require 'rest-client'

  included do
    before_action :authenticate_user
    layout 'embedded_app'
  end

  def authenticate_user
      if session[:shopify_user].present?
        redirect_to root_path
      else
        @token = RestClient.post "https://#{params[:shop]}/admin/oauth/access_token", {client_id: ENV['SHOPIFY_APP_API_KEY'], client_secret: ENV['SHOPIFY_APP_SECRET'], code: params[:code]}
      end
  end

end
