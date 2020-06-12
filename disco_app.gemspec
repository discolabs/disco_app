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
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails'
  s.add_dependency 'shopify_app'
  s.add_dependency 'puma', '~> 3.12'
  s.add_dependency 'sidekiq'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'turbolinks'
  s.add_dependency 'pg'
  s.add_dependency 'rails_12factor'
  s.add_dependency 'active_utils'
  s.add_dependency 'activerecord-session_store'
  s.add_dependency 'omniauth-shopify-oauth2'
  s.add_dependency 'jsonapi-resources'
  s.add_dependency 'react-rails'
  s.add_dependency 'classnames-rails'
  s.add_dependency 'render_anywhere'
  s.add_dependency 'sass'
  s.add_dependency 'uglifier'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'dotenv-rails'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'webmock'
end
