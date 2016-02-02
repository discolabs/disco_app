module DiscoApp
  module Generators
    class AdminifyGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      # Run disco_app:reactfy since the admin section needs react
      def reactify_install
        generate 'disco_app:reactify'
      end

      def configure_gem
        #install jsonapi-resources
        gem 'jsonapi-resources', '~> 0.7.0'
      end

      def setup_routes
        routes = <<-CONFIG.strip_heredoc

          controller 'admin' do
            get 'admin', to: redirect('/admin/shops') 
            get 'admin/shops' => 'admin/shops#index'
          end

          namespace :admin do
            resources :shops, path: '/shops', only: [:index, :edit, :update]
            
            # JSON-API resources for admins."
            namespace :resources do
              jsonapi_resources :shops
            end
          end
        CONFIG
        route routes
      end

      def add_env_variables
        env_variables = <<-CONFIG.strip_heredoc

          ADMIN_APP_USERNAME=
          ADMIN_APP_PASSWORD=
        CONFIG
        append_to_file '.env', env_variables 
        append_to_file '.env.local', env_variables 
      end

    end
  end
end
