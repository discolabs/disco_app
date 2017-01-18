class MoveShopToDiscoAppEngine < ActiveRecord::Migration
  def change
    rename_table :shops, :disco_app_shops
  end
end
