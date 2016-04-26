class AddTrialPeriodDaysToDiscoAppSubscriptions < ActiveRecord::Migration
  def change
    add_column :disco_app_subscriptions, :trial_period_days, :integer
  end
end
