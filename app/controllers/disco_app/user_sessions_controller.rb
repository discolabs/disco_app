class DiscoApp::UserSessionsController < ApplicationController
  include DiscoApp::Concerns::UserAuthenticatedController

  skip_before_action :shopify_user

  def new
  end

  def create
    authenticate
  end

  def callback
    if auth_hash
      login_user
      redirect_to return_address
    else
      redirect_to root_path
    end
  end

  def destroy
    session[:shopify_user] = nil
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def associated_user(auth_hash)
    auth_hash['extra']['associated_user']
  end

  def authenticate
    if sanitized_shop_name.present?
      fullpage_redirect_to "#{main_app.root_path}auth/shopify_user?shop=#{sanitized_shop_name}"
    else
      redirect_to return_address
    end
  end

  def login_user
    @user = DiscoApp::User.create_from_auth(associated_user(auth_hash), session[:shopify])
    session[:shopify_user] = @user.id
  end

  def sanitized_shop_name
    @sanitized_shop_name ||= session[:shopify_domain]
  end

  def return_address
    session.delete(:return_to) || main_app.root_url
  end

end

