module DiscoApp::Concerns::SynchroniseUsersJob
  extend ActiveSupport::Concern

  def perform(_shop)
    begin
      users = @shop.with_api_context {
        ShopifyAPI::User.all
      }
    rescue ActiveResource::UnauthorizedAccess => e
      Rollbar.error(e) and return
    end
    users.each { |user| DiscoApp::User.create_user(user, @shop) }
  end

end
