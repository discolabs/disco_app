class CreateCarts < ActiveRecord::Migration[4.2]

def change
    create_table :carts do |t|
      t.integer :shop_id, limit: 8
      t.string :token
      t.jsonb :data

      t.timestamps null: false
    end
    add_foreign_key :carts, :disco_app_shops, column: :shop_id
    add_index :carts, :token, unique: true
  end
end
