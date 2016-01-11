module DiscoApp
  module Generators
    class RollbarifyGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      # Install the Rollbar and OJ gems.
      def install_gems
        # Add gem to Gemfile
        gem 'rollbar', '~> 2.7.1'
        gem 'oj', '~> 2.14.3'

        # Install gem.
        Bundler.with_clean_env do
          run 'bundle install'
        end
      end

      # Copy initializer.
      def configure
        copy_file 'initializers/rollbar.rb', 'config/initializers/rollbar.rb'
      end

    end
  end
end
