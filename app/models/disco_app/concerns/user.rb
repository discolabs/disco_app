module DiscoApp::Concerns::User
  extend ActiveSupport::Concern

  included do
    belongs_to :shop

    def self.create_from_auth(shopify_user, shop)
      self.find_or_create_by(id: shopify_user.id, shop_id: shop) do |user|
        user.first_name = shopify_user.first_name || ''
        user.last_name = shopify_user.last_name || ''
        user.email = shopify_user.email
      end
    end

  end
end
