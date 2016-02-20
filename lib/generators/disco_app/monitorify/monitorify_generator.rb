module DiscoApp
  module Generators
    class MonitorifyGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      # Install the Rollbar, OJ and New Relic gems.
      def install_gems
        # Add gem to Gemfile
        gem 'rollbar', '~> 2.8.0'
        gem 'oj', '~> 2.14.5'
        gem 'newrelic_rpm', '~> 3.14.1.314'

        # Install gem.
        Bundler.with_clean_env do
          run 'bundle install'
        end
      end

      # Copy Rollbar initializer and New Relic config file.
      def configure
        copy_file 'initializers/rollbar.rb', 'config/initializers/rollbar.rb'
        copy_file 'config/newrelic.yml', 'config/newrelic.yml'
      end

    end
  end
end
