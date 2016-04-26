class AddSourceToDiscoAppSubscriptions < ActiveRecord::Migration
  def change
    add_column :disco_app_subscriptions, :source, :string
  end
end
