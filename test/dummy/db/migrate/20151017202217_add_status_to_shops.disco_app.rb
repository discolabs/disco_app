# This migration comes from disco_app (originally 20150525162112)
class AddStatusToShops < ActiveRecord::Migration
  def change
    add_column :shops, :status, :integer, default: 0
  end
end
