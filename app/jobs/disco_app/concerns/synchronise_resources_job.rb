module DiscoApp::Concerns::SynchroniseResourcesJob

  extend ActiveSupport::Concern

  def perform(shop, class_name, since_id = 0)
    DiscoApp::SynchroniseResourcesService.synchronise_all(shop, class_name, since_id)
  end

end
