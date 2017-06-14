module DiscoApp::Concerns::SynchroniseUsersJob
  extend ActiveSupport::Concern

  def perform(_shop)
    users = @shop.with_api_context {
      ShopifyAPI::User.all
    }
    return unless users.present?
    users.each { |user| DiscoApp::User.create_user(user, @shop) }
  end

end
