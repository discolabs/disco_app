module DiscoApp
  module Generators
    class AdminifyGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      # Run disco_app:reactfy since the admin section needs react
      def reactify_install
        generate 'disco_app:reactify'
      end

      def configure_gems
        gem 'active_link_to', '~> 1.0.2'
      end

      def add_env_variables
        env_variables = <<-CONFIG.strip_heredoc

          ADMIN_APP_USERNAME=
          ADMIN_APP_PASSWORD=
        CONFIG
        append_to_file '.env', env_variables 
        append_to_file '.env.local', env_variables 
      end

      # Run bundle install to add our new gems before running tasks.
      def bundle_install
        Bundler.with_clean_env do
          run 'bundle install'
        end
      end

    end
  end
end
