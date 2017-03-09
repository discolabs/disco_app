namespace :api do

  desc 'Send all subscription information to the Disco API'
  task send_subscriptions: :environment do
    DiscoApp::Shop.find_each do |shop|
      DiscoApp::SendSubscriptionJob.perform_later(shop)
    end
  end

end
