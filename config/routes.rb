DiscoApp::Engine.routes.draw do

  controller :webhooks do
    post 'webhooks' => :process_webhook, as: :webhooks
  end

  controller :charges do
    get 'charges/new' => :new, as: :new_charge
    post 'charges/create' => :create, as: :create_charge
    get 'charges/activate' => :activate, as: :activate_charge
  end

  controller :install do
    get 'install' => :install, as: :install
    get 'installing' => :installing, as: :installing
    get 'uninstalling' => :uninstalling, as: :uninstalling
  end

  # Make the embedded app frame emulator available in development.
  if Rails.env.development?
    controller :frame do
      get 'frame' => :frame, as: :frame
    end
  end

end
