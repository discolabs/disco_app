class Product < ActiveRecord::Base
  include DiscoApp::Concerns::Synchronises
end
