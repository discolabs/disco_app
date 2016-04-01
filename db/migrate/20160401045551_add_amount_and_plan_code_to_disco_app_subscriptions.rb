class AddAmountAndPlanCodeToDiscoAppSubscriptions < ActiveRecord::Migration
  def change
    add_column :disco_app_subscriptions, :amount, :integer, default: 0
    add_column :disco_app_subscriptions, :plan_code_id, :integer, limit: 8
    add_foreign_key :disco_app_subscriptions, :disco_app_plan_codes, column: :plan_code_id
  end
end
