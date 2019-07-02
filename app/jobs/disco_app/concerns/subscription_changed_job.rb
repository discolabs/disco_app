module DiscoApp::Concerns::SubscriptionChangedJob

  extend ActiveSupport::Concern

  def perform(_shop, _subscription)
    DiscoApp::SendSubscriptionJob.perform_later(@shop)
  end

end
