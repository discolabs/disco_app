module DiscoApp
  class ApplicationController
    extend ActiveSupport::Concern
    include ShopifyApp::Controller
  end
end