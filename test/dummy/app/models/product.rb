class Product < ApplicationRecord

  include DiscoApp::Concerns::Synchronises

  include DiscoApp::Concerns::HasMetafields
  SHOPIFY_API_CLASS = ShopifyAPI::Product

  belongs_to :shop, class_name: 'DiscoApp::Shop'

end
