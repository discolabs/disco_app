DiscoApp::Engine.routes.default_url_options[:host] = ENV['DEFAULT_HOST']

DiscoApp.configure do |config|
  config.skip_proxy_verification = ENV['SKIP_PROXY_VERIFICATION']
end
