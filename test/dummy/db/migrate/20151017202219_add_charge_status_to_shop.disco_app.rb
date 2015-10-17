# This migration comes from disco_app (originally 20150629210346)
class AddChargeStatusToShop < ActiveRecord::Migration
  def change
    add_column :shops, :charge_status, :integer, default: 6
  end
end
