class CreateDiscoAppPlans < ActiveRecord::Migration
  def change
    create_table :disco_app_plans do |t|
      t.integer :status
      t.string :name
      t.integer :charge_type
      t.decimal :default_price
      t.integer :default_trial_days

      t.timestamps null: false
    end
  end
end
