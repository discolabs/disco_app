# Prevent warnings from showing up during testing.
$VERBOSE = nil

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
ENV['DEFAULT_HOST'] = 'https://test.example.com'
ENV['SHOPIFY_APP_NAME'] = 'Test Application'
ENV['SHOPIFY_APP_API_KEY'] = 'f61b26d635309536c3c83c0adc3cb972'
ENV['SHOPIFY_APP_SECRET'] = 'b607d1f8b992dccb017f9315f07af9c4'
ENV['SHOPIFY_APP_REDIRECT_URI'] = 'https://test.example.com/shopify/auth/callback'
ENV['SHOPIFY_APP_SCOPE'] = 'read_products'
ENV['SHOPIFY_CHARGES_REAL'] = 'false'
ENV['DISCO_API_URL'] = 'https://api.discolabs.com/v1/'

require File.expand_path('../test/dummy/config/environment.rb', __dir__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __dir__)
require 'rails/test_help'

# Require our additional test support helpers.
require 'support/test_file_fixtures'
require 'support/test_shopify_api'

# Require WebMock
require 'webmock/minitest'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
  ActiveSupport::TestCase.fixtures :all
end

# Add VCR to allow the recording and playback of HTTP Requests and Responses
require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr'
  config.hook_into :webmock
  config.default_cassette_options = { match_requests_on: [:method, :uri, :body], decode_compressed_response: true }
end

# Minitest helpers to give a better formatted and more helpful output in Rubymine
require 'minitest/reporters'
require 'minitest/autorun'
MiniTest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Set up the base test class.
class ActiveSupport::TestCase

  fixtures :all

  # Include helper modules common to all tests.
  include DiscoApp::Test::FileFixtures

  def log_in_as(shop)
    session[:shopify] = shop.id
    session[:shopify_domain] = shop.shopify_domain
    session[:api_version] = shop.api_version
  end

  def log_out
    session[:shopify] = nil
    session[:shopify_domain] = nil
    session[:api_version] = nil
  end

end
