Rollbar.configure do |config|
  # Fetch the access token from the environment.
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  # Only use Rollbar in production when there's a token configured.
  config.enabled = false unless config.access_token && Rails.env.production?

  # Enable delayed reporting (using Sidekiq)
  config.use_sidekiq

  # Enable "Person" feature of Rollbar in the context of a "Shop"
  config.person_method = 'current_shop'
  config.person_username_method = 'shopify_domain'

  # Add custom handlers.
  config.before_process << proc do |options|
    if options[:exception].is_a?(ActiveResource::ClientError) && options[:exception].message.include?('Too Many Requests')
      raise Rollbar::Ignore
    end
  end
end
