Rails.application.routes.draw do

  root to: 'home#index'

  mount ShopifyApp::Engine, at: '/'
  mount DiscoApp::Engine, at: '/'

end
