class CreateDiscoAppSubscriptions < ActiveRecord::Migration
  def change
    create_table :disco_app_subscriptions do |t|
      t.belongs_to :shop, index: true
      t.belongs_to :plan, index: true
      t.integer :status
      t.string :name
      t.integer :charge_type
      t.decimal :price
      t.integer :trial_days

      t.timestamps null: false
    end
  end
end
