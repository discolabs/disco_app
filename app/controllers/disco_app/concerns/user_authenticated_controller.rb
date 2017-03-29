module DiscoApp::Concerns::UserAuthenticatedController
  extend ActiveSupport::Concern
  include ShopifyApp::LoginProtection

  included do
    before_action :shopify_user
    around_filter :shopify_session
    layout 'embedded_app'
  end

  private

  def shopify_user
    if session[:shopify_user]
      @user = DiscoApp::User.find_by!(id: session[:shopify_user])
    else
      redirect_to disco_app.new_user_session_path
    end
  end

end
