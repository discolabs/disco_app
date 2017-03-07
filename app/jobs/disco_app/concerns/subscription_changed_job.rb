module DiscoApp::Concerns::SubscriptionChangedJob
  extend ActiveSupport::Concern

  def perform(shop, subscription)
    DiscoApp::SendSubscriptionJob.perform_later(@shop)
  end

end
