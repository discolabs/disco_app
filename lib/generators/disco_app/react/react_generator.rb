module DiscoApp
  module Generators
    class ReactGenerator < Rails::Generators::Base

      source_root File.expand_path('templates', __dir__)

      def prepare_application
        copy_file 'root/VERSION', 'VERSION'
      end

      def configure_gemfile
        gem 'fast_jsonapi'
        gem 'multi_json'
        gem 'oj'
        gem 'olive_branch'
        gem 'webpacker'
      end

      def bundle_install
        Bundler.with_clean_env do
          run 'bundle install'
        end
      end

      def configure_application
        application 'config.middleware.use OliveBranch::Middleware'
        application '# Camel-case to underscore transformation for JSON requests.'

        copy_file 'config/initializers/mime_types.rb'
        copy_file 'config/initializers/omniauth.rb'
        template 'config/initializers/version.rb.tt', 'config/initializers/version.rb'

        %w[.env .env.local].each do |file|
          append_to_file file, 'BUGSNAG_API_KEY=00000000'
        end
      end

      def update_routes
        routes = <<-ROUTES.gsub(/^ {8}/, '')
          # Embedded React routes.
          root to: 'embedded/home#index'

          # Embedded API.
          namespace :embedded do
            namespace :api, constraints: { format: :json }, defaults: { format: :json } do
              resource :shop, only: [:show]

              resources :users, only: [] do
                get :current, on: :collection
              end
            end
          end
        ROUTES

        route routes

        comment_lines 'config/routes.rb', "root to: 'home#index'"
      end

      def install_webpacker
        rake 'webpacker:install'
      end

      def configure_webpack
        %w[.eslintignore .eslintrc .prettierrc babel.config.js postcss.config.js].each do |file|
          copy_file "root/#{file}", file
        end

        template 'root/package.json.tt', 'package.json'

        copy_file 'config/webpacker.yml'
        copy_file 'config/webpack/staging.js'
        copy_file 'config/webpack/test.js'

        run "if [ -d 'app/javascript' ]; then mv -f app/javascript app/webpack; fi"
      end

      def yarn_install
        run 'yarn install'
      end

      def configure_api
        directory 'app/controllers/embedded'
      end

      def configure_views
        directory 'app/views/embedded'
        copy_file 'app/views/layouts/embedded.html.erb'
      end

      def configure_serializers
        directory 'app/serializers'
      end

      def configure_api_response
        copy_file 'app/models/api_response.rb'
      end

      def configure_react
        directory 'app/webpack/javascripts'
        directory 'app/webpack/stylesheets'
        copy_file 'app/webpack/packs/embedded.js'
        remove_file 'app/webpack/packs/application.js'
      end

    end
  end
end