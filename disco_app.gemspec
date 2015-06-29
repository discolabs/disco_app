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

  s.add_dependency "rails", "~> 4.2.1"
  s.add_dependency "shopify_app", "~> 6.1.2"
  s.add_dependency "puma", "~> 2.11.3"
  s.add_dependency "sidekiq", "~> 3.3.4"
  s.add_dependency "pg", "~> 0.18.2"
  s.add_dependency "rails_12factor", "~> 0.0.3"

  s.add_development_dependency "sqlite3", "~> 1.3.10"
  s.add_development_dependency "dotenv-rails", "~> 2.0.2"
end
