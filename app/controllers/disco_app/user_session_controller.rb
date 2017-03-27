class DiscoApp::UserSessionController < ApplicationController
  include DiscoApp::Concerns::UserAuthenticatedController

   def callback
     if @token
       @token = JSON.parse(@token.body)
       @user = DiscoApp::User.create_from_auth(@token['associated_user'], session[:shopify])
       session['shopify_user'] = @user.id
       redirect_to root_path
     else
       redirect_to root_path
     end
   end

end
