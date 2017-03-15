class AddSourcesToShopSubscriptions < ActiveRecord::Migration
  def change
    add_column :disco_app_subscriptions, :source_id, :integer, limit: 8, index: true
    add_foreign_key :disco_app_subscriptions, :disco_app_sources, column: :source_id

    DiscoApp::Subscription.where.not(source: nil).each do |subscription|
      source = DiscoApp::Source.find_or_create_by(name: subscription.source)
      subscription.update!(source: source)
    end
    remove_column :disco_app_subscriptions, :source
  end
end
