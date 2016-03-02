class DropChargeStatusFromShops < ActiveRecord::Migration
  def change
    remove_column :disco_app_shops, :charge_status, :integer, default: 0
  end
end
