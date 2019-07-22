module DiscoApp::Concerns::User

  extend ActiveSupport::Concern

  included do
    belongs_to :shop

    def self.create_user(shopify_user, shop)
      user = find_or_create_by!(id: shopify_user.id, shop: shop)
      user.update(
        first_name: shopify_user.first_name || '',
        last_name: shopify_user.last_name || '',
        email: shopify_user.email
      )
      user
    rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
      retry
    end
  end

end
