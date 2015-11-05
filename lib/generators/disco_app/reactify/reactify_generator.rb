module DiscoApp
  module Generators
    class ReactifyGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      # Install the react-rails gem and run its setup.
      def install_gem
        # Add gem to Gemfile
        gem 'react-rails', '~> 1.4.0'

        # Install gem.
        Bundler.with_clean_env do
          run 'bundle install'
        end

        # Run the gem's generator.
        generate 'react:install'
      end

      # Set application configuration
      def configure_application
        application "config.react.variant = :development", env: :development
        application "# Use development variant of React in development.", env: :development
        application "config.react.variant = :production", env: :production
        application "# Use production variant of React in production.", env: :production
      end

    end
  end
end
