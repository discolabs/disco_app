$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "disco_app/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "disco_app"
  s.version     = DiscoApp::VERSION
  s.authors     = ["Gavin Ballard"]
  s.email       = ["gavin@gavinballard.com"]
  s.homepage    = "https://github.com/discolabs/disco_app/"
  s.summary     = "Rails engine for Shopify applications."
  s.description = "Rails engine for Shopify applications."
  s.license     = "None"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency 'rails', '~> 4.2'
  s.add_runtime_dependency 'shopify_app', '~> 6.4'
  s.add_runtime_dependency 'puma', '~> 2.14'
  s.add_runtime_dependency 'sidekiq', '~> 4.2'
  s.add_runtime_dependency 'pg', '~> 0.19.0'
  s.add_runtime_dependency 'rails_12factor', '~> 0.0.3'
  s.add_runtime_dependency 'rails-bigint-pk', '~> 1.2'
  s.add_runtime_dependency 'active_utils', '~> 3.2'
  s.add_runtime_dependency 'activerecord-session_store', '~> 1.0'
  s.add_runtime_dependency 'jsonapi-resources', '~> 0.8'
  s.add_runtime_dependency 'acts_as_singleton', '~> 0.0.8'
  s.add_runtime_dependency 'react-rails', '~> 1.10'
  s.add_runtime_dependency 'classnames-rails', '~> 2.1'
  s.add_runtime_dependency 'render_anywhere', '~> 0.0.12'
  s.add_runtime_dependency 'sinatra', '~> 1.4'
  s.add_runtime_dependency 'active_link_to', '~> 1.0'
  s.add_runtime_dependency 'premailer-rails', '~> 1.8'
  s.add_runtime_dependency 'nokogiri', '~> 1.7'
  s.add_runtime_dependency 'rollbar', '~> 2.14'
  s.add_runtime_dependency 'oj', '~> 2.14'
  s.add_runtime_dependency 'newrelic_rpm', '~> 3.15'
  s.add_runtime_dependency 'mailgun_rails', '~> 0.8'

  s.add_development_dependency 'dotenv-rails', '~> 2.0'
  s.add_development_dependency 'minitest-reporters', '~> 1.0'
  s.add_development_dependency 'webmock', '~> 2.3'
  s.add_development_dependency 'vcr', '~> 3.0'
end
