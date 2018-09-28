class FixDiscoAppUsersIndex < ActiveRecord::Migration[5.1]

  def change
    remove_index :disco_app_users, :shop_id
    add_index :disco_app_users, [:id, :shop_id], unique: true
  end

end
