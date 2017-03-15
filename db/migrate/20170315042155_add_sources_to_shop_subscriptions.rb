class AddSourcesToShopSubscriptions < ActiveRecord::Migration
  def change
    remove_column :disco_app_subscriptions, :source
    add_column :disco_app_subscriptions, :source_id, :integer, limit: 8, index: true
    add_foreign_key :disco_app_subscriptions, :disco_app_sources, column: :source_id
  end

end
