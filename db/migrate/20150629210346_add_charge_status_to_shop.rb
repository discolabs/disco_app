class AddChargeStatusToShop < ActiveRecord::Migration
  def change
    if table_exists? :shops
      add_column :shops, :charge_status, :integer, default: 6
    end
  end
end
