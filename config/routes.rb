DiscoApp::Engine.routes.draw do
  controller :webhooks do
    post 'webhooks' => :process_webhook, as: :webhooks
  end
end
