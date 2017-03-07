namespace :api do

  desc "Sends subscription to disco API"
  task send_subscription: :environment do
    unless ENV['DISCO_API_URL'].empty?
      DiscoApp::Shop.installed.has_active_shopify_plan.each do |shop|
        DiscoApp::SendSubscriptionJob.perform_later(shop)
      end
    end
  end

end
