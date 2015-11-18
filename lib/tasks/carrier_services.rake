namespace :carrier_services do

  desc 'Synchronise carrier services across all installed shops.'
  task sync: :environment do
    DiscoApp::Shop.installed.has_active_shopify_plan.each do |shop|
      DiscoApp::SynchroniseCarrierServicesJob.perform_later(shop.shopify_domain)
    end
  end

end
