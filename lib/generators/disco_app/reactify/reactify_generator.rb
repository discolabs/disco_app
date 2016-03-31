module DiscoApp
  module Generators
    class ReactifyGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      # Install the react-rails gem and run its setup.
      def install_gem
        # Add gem to Gemfile
        gem 'react-rails', '~> 1.6.0'

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

      # Include the DiscoApp component library in the application.js manifest.
      def add_to_manifest
        inject_into_file manifest, "//= require disco_app/components\n", { before: "//= require components\n" }
      end

      private

        # This method of finding the application.js manifest taken from the
        # install generator in react-rails.
        # See https://github.com/reactjs/react-rails/blob/3f0af13fa755d6e95969c17728d0354c234f3a37/lib/generators/react/install_generator.rb#L53-L55
        def manifest
          Pathname.new(destination_root).join('app/assets/javascripts', 'application.js')
        end

    end
  end
end
