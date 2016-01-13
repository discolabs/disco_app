class AddShopIdToDiscoAppSessions < ActiveRecord::Migration
  def change
    add_column :disco_app_sessions, :shop_id, :integer, null: true
    add_foreign_key :disco_app_sessions, :disco_app_shops, column: :shop_id, on_delete: :cascade
  end
end
