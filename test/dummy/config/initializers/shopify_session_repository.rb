if Rails.configuration.cache_classes
  ShopifyApp::SessionRepository.storage = DiscoApp::SessionStorage
else
  ActionDispatch::Reloader.to_prepare do
    ShopifyApp::SessionRepository.storage = DiscoApp::SessionStorage
  end
end
