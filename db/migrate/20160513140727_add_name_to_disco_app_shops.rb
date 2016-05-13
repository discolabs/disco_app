class AddNameToDiscoAppShops < ActiveRecord::Migration
  def change
    add_column :disco_app_shops, :name, :string
  end
end
