DiscoApp::Engine.routes.draw do

  get 'ref', to: '/sessions#referral'

  controller :webhooks do
    post 'webhooks' => :process_webhook, as: :webhooks
  end

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
    resources :shops, only: [:index, :edit, :update]
    resources :plans
    resource :app_settings, only: [:edit, :update]

    # JSON-API resources for admins."
    namespace :resources do
      jsonapi_resources :shops
    end
  end

  # Make the embedded app frame emulator available in development.
  if Rails.env.development?
    controller :frame do
      get 'frame' => :frame, as: :frame
    end
  end

end
