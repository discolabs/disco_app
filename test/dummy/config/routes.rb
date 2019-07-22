Rails.application.routes.draw do
  root to: 'home#index'

  get '/proxy', to: 'proxy#index'
  post '/rates', to: 'carrier_request#rates', as: :carrier_service_callback

  mount ShopifyApp::Engine, at: '/'
  mount DiscoApp::Engine, at: '/'
end
