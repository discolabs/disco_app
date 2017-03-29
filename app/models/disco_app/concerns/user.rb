module DiscoApp::Concerns::User
  extend ActiveSupport::Concern

  included do
    belongs_to :shop

    def self.create_from_auth(shopify_user, shop)
      self.find_or_create_by(id: shopify_user.id, shop: shop).update(
        first_name: shopify_user.first_name || '',
        last_name: shopify_user.last_name || '',
        email: shopify_user.email
      )
    end

  end
end
