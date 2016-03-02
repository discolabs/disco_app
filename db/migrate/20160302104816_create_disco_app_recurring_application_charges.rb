class CreateDiscoAppRecurringApplicationCharges < ActiveRecord::Migration
  def change
    create_table :disco_app_recurring_application_charges do |t|
      t.belongs_to :shop, index: { name: 'index_recurring_charges_on_shops' }, foreign_key: true
      t.belongs_to :subscription, index: { name: 'index_recurring_charges_on_subscriptions'} , foreign_key: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
