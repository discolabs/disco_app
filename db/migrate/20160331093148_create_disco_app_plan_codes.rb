class CreateDiscoAppPlanCodes < ActiveRecord::Migration
  def change
    create_table :disco_app_plan_codes do |t|
      t.integer :plan_id, limit: 8
      t.string :code
      t.integer :trial_period_days
      t.integer :amount

      t.timestamps null: false
    end

    add_foreign_key :disco_app_plan_codes, :disco_app_plans, column: :plan_id
  end
end
