Rails.application.routes.draw do

  root to: 'home#index'

  get '/proxy', to: 'proxy#index'

  mount ShopifyApp::Engine, at: '/'
  mount DiscoApp::Engine, at: '/'

end
