module DiscoApp::Concerns::SynchroniseUsersJob

  extend ActiveSupport::Concern

  def perform(_shop)
    begin
      users = @shop.with_api_context do
        ShopifyAPI::User.all
      end
    rescue ActiveResource::UnauthorizedAccess => e
      Appsignal.set_error(e)
      return
    end

    users.each { |user| DiscoApp::User.create_user(user, @shop) }
  end

end
