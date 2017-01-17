class MoveShopToDiscoAppEngine < ActiveRecord::Migration
  def change
    if table_exists? :shops
      rename_table :shops, :disco_app_shops
    end
  end
end
