Rails.application.routes.draw do

  root :to => 'home#index'

  mount DiscoApp::Engine, at: '/'
  mount ShopifyApp::Engine, at: '/'

end
