namespace :shops do
  desc 'Synchronise shop data across all installed shops.'
  task sync: :environment do
    DiscoApp::Shop.installed.has_active_shopify_plan.each do |shop|
      DiscoApp::ShopUpdateJob.perform_later(shop)
    end
  end
end
