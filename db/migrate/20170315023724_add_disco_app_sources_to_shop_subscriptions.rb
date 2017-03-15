class AddDiscoAppSourcesToShopSubscriptions < ActiveRecord::Migration

  def change
    remove_column :disco_app_subscriptions, :source
    add_reference :disco_app_subscriptions, :disco_app_source, index: true, foreign_key: true
  end

end
