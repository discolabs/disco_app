namespace :carrier_service do

  desc 'Synchronise carrier service across all installed shops.'
  task sync: :environment do
    DiscoApp::Shop.installed.has_active_shopify_plan.each do |shop|
      DiscoApp::SynchroniseCarrierServiceJob.perform_later(shop.shopify_domain)
    end
  end

end
