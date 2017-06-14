namespace :users do

  desc 'Synchronise user data accross all installed shops'
  task sync: :environment do
    DiscoApp::Shop.installed.has_active_shopify_plan.shopify_plus.each do |shop|
      DiscoApp::SynchroniseUsersJob.perform_later(shop)
    end
  end

end
