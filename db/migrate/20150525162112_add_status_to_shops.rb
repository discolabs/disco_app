class AddStatusToShops < ActiveRecord::Migration
  def change
    add_column :shops, :status, :integer, default: 0
  end
end
