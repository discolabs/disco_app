class CreateDiscoAppApplicationCharges < ActiveRecord::Migration
  def change
    create_table :disco_app_application_charges do |t|
      t.integer :shop_id, limit: 8
      t.integer :subscription_id, limit: 8
      t.integer :status, default: 0

      t.timestamps null: false
    end

    add_foreign_key :disco_app_application_charges, :disco_app_shops, column: :shop_id
    add_foreign_key :disco_app_application_charges, :disco_app_subscriptions, column: :subscription_id
  end
end
