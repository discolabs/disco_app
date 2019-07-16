namespace :webhooks do
  desc 'Synchronise webhooks across all installed shops.'
  task sync: :environment do
    DiscoApp::Shop.installed.has_active_shopify_plan.each do |shop|
      DiscoApp::SynchroniseWebhooksJob.perform_later(shop)
    end
  end
end
