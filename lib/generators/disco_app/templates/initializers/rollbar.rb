Rollbar.configure do |config|
  # Fetch the access token from the environment.
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  # Only use Rollbar in production when there's a token configured.
  unless config.access_token and Rails.env.production?
    config.enabled = false
  end

  # Enable delayed reporting (using Sidekiq)
  config.use_sidekiq
end
