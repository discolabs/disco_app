class AddChargeStatusToShop < ActiveRecord::Migration
  def change
    add_column :shops, :charge_status, :integer, default: 0
  end
end
