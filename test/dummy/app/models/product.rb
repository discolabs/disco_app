class Product < ActiveRecord::Base
  include DiscoApp::Concerns::Synchronises

  belongs_to :shop, class_name: 'DiscoApp::Shop'

end
