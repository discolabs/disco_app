class Product < ActiveRecord::Base
  include DiscoApp::Concerns::Synchronises
  include DiscoApp::Concerns::HasMetafields

  belongs_to :shop, class_name: 'DiscoApp::Shop'

  SHOPIFY_API_CLASS = ShopifyAPI::Product

end
