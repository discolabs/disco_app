if Rails.configuration.cache_classes
  ShopifyApp::SessionRepository.storage = DiscoApp::SessionStorage
else
  reloader = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
  reloader.to_prepare do
    ShopifyApp::SessionRepository.storage = DiscoApp::SessionStorage
  end
end
