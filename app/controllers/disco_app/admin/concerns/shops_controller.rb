module DiscoApp::Admin::Concerns::ShopsController
  extend ActiveSupport::Concern

  def index
    @shops = DiscoApp::Shop.all
  end

end
