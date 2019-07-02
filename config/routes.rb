require 'sidekiq/web'

DiscoApp::Engine.routes.draw do
  get 'ref', to: '/sessions#referral'
  get '/auth/failure', to: '/sessions#failure'

  controller :webhooks do
    post 'webhooks' => :process_webhook, as: :webhooks
  end

  namespace :flow do
    controller :actions do
      post 'actions/:id' => :create_flow_action, as: :flow_actions
    end
  end

  resources :user_sessions, only: [:new, :create, :destroy]
  get 'auth/shopify_user/callback' => 'user_sessions#callback'

  resources :subscriptions, only: [:new, :create] do
    resources :charges, only: [:new, :create] do
      member do
        get 'activate'
      end
    end
  end

  controller :install do
    get 'install' => :install, as: :install
    get 'installing' => :installing, as: :installing
    get 'uninstalling' => :uninstalling, as: :uninstalling
  end

  controller 'admin' do
    get 'admin', to: redirect('/admin/shops')
    get 'admin/shops' => 'admin/shops#index'
  end

  namespace :admin do
    resources :shops, only: [:index, :edit, :update] do
      resources :subscriptions, only: [:edit, :update]
    end
    resources :plans
    resources :sources
    resource :app_settings, only: [:edit, :update]

    # JSON-API resources for admins.
    namespace :resources do
      jsonapi_resources :shops
    end
  end

  # Make the Sidekiq Web UI accessible using the same credentials as the admin.
  if Rails.env.production? || Rails.env.staging?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      [
        ENV['ADMIN_APP_USERNAME'].present?,
        ENV['ADMIN_APP_USERNAME'] == username,
        ENV['ADMIN_APP_PASSWORD'].present?,
        ENV['ADMIN_APP_PASSWORD'] == password,
      ].all?
    end
    mount Sidekiq::Web, at: '/sidekiq'
  end

  # Make the embedded app frame emulator available in development.
  if Rails.env.development?
    controller :frame do
      get 'frame' => :frame, as: :frame
    end
  end
end
