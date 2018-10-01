class CreateDiscoAppUsers < ActiveRecord::Migration[5.1]

  def change
    create_table :disco_app_users do |t|
      t.integer :shop_id, limit: 8
      t.string :first_name
      t.string :last_name
      t.string :email
      t.timestamps null: false
    end
    add_index :disco_app_users, :shop_id, unique: true
  end

end
