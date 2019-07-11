if Rails.env.production?
  http_device = Timber::LogDevices::HTTP.new('YOUR_API_KEY', 'YOUR_SOURCE_ID')
  Rails.logger = Timber::Logger.new(http_device)
else
  Rails.logger = Timber::Logger.new(STDOUT)
end
