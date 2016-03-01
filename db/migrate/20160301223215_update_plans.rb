class UpdatePlans < ActiveRecord::Migration
  def change
    remove_column :disco_app_plans, :default_price, :decimal
    rename_column :disco_app_plans, :default_trial_days, :trial_period_days
    rename_column :disco_app_plans, :charge_type, :plan_type
    add_column :disco_app_plans, :amount, :integer, default: 0
    add_column :disco_app_plans, :currency, :string, default: 'USD'
    add_column :disco_app_plans, :interval, :integer, default: 0
    add_column :disco_app_plans, :interval_count, :integer, default: 1

    reversible do |direction|
      direction.up do
        change_column :disco_app_plans, :plan_type, :integer, default: 0
      end
      direction.down do
        change_column :disco_app_plans, :plan_type, :integer
      end
    end
  end
end
