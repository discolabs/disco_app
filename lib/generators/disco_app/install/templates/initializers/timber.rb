if ENV['TIMBER_API_KEY'] && ENV['TIMBER_SOURCE_ID']
  http_device = Timber::LogDevices::HTTP.new(ENV['TIMBER_API_KEY'], ENV['TIMBER_SOURCE_ID'])
  Rails.logger = Timber::Logger.new(http_device)
end
