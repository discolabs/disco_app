class UpdateSubscriptions < ActiveRecord::Migration
  def change
    remove_column :disco_app_subscriptions, :name, :string
    remove_column :disco_app_subscriptions, :price, :decimal
    remove_column :disco_app_subscriptions, :trial_days, :integer

    rename_column :disco_app_subscriptions, :charge_type, :subscription_type

    add_column :disco_app_subscriptions, :trial_start_at, :datetime, null: true
    add_column :disco_app_subscriptions, :trial_end_at, :datetime, null: true
    add_column :disco_app_subscriptions, :cancelled_at, :datetime, null: true
  end
end
