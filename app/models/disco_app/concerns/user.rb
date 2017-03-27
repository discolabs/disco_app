module DiscoApp::Concerns::User
  extend ActiveSupport::Concern

  belongs_to :shop

  def self.create_from_auth(auth_hash, shop)
    self.find_or_create_by(id: auth_hash['id'], shop_id: shop) do |user|
      user.first_name = auth_hash['first_name'] || ''
      user.last_name = auth_hash['last_name'] || ''
      user.email = auth_hash['email']
    end
  end
end
