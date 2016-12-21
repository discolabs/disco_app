class AddEncryptionToShopifyToken < ActiveRecord::Migration
  def change
    rename_column :disco_app_shops, :shopify_token, :encrypted_shopify_token_iv
  end
end
