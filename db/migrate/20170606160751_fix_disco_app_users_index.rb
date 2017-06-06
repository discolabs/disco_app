class FixDiscoAppUsersIndex < ActiveRecord::Migration
  def change
    remove_index :disco_app_users, :shop_id
    add_index :disco_app_users, [:id, :shop_id], unique: true
  end
end
