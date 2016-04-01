class AddStatusToPlanCodes < ActiveRecord::Migration
  def change
    add_column :disco_app_plan_codes, :status, :integer, default: 0
  end
end
