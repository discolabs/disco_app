module DiscoApp
  module ApplicationController
    extend ActiveSupport::Concern
    include ShopifyApp::Controller
  end
end