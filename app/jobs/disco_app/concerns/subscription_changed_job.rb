module DiscoApp::Concerns::SubscriptionChangedJob
  extend ActiveSupport::Concern

  def perform(_shop, subscription)
    DiscoApp::SendSubscriptionJob.perform_later(@shop)
  end

end
