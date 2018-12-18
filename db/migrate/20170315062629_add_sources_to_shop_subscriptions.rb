class AddSourcesToShopSubscriptions < ActiveRecord::Migration[5.1]

  def change
    add_column :disco_app_subscriptions, :source_id, :integer, limit: 8, index: true
    add_foreign_key :disco_app_subscriptions, :disco_app_sources, column: :source_id

    DiscoApp::Subscription.where.not(source: nil).find_each do |subscription|
      DiscoApp::Source.find_or_create_by(source: subscription.source) do |new_source|
        new_source.name = subscription.source
      end
    end

    remove_column :disco_app_subscriptions, :source
  end

end
