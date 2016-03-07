class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :shop_id, limit: 8
      t.jsonb :data

      t.timestamps null: false
    end
    add_foreign_key :products, :disco_app_shops, column: :shop_id
  end
end
