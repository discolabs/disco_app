class AddStatusToShops < ActiveRecord::Migration
  def change
    if table_exists? :shops
      add_column :shops, :status, :integer, default: 0
    end
  end
end
