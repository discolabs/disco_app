module DiscoApp
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path('templates', __dir__)

      # Copy a number of template files to the top-level directory of our application:
      #
      #  - .env and .env.local for settings environment variables in development with dotenv-rails;
      #  - Slightly customised version of the default Rails .gitignore;
      #  - Default simple Procfile for Heroku;
      #  - .editorconfig to help enforce 2-space tabs, newlines and truncated whitespace for editors that support it.
      #  - README/PULL REQUEST template
      #
      def copy_root_files
        %w[.editorconfig .env .env.local .gitignore .rubocop.yml Procfile CHECKS README.md].each do |file|
          copy_file "root/#{file}", file
        end
        directory 'root/.github'
      end

      # Remove a number of root files.
      def remove_root_files
        %w[README.rdoc].each do |file|
          remove_file file
        end
      end

      # Configure the application's Gemfile.
      def configure_gemfile
        # Remove sqlite.
        gsub_file 'Gemfile', /^# Use sqlite3 as the database for Active Record\ngem 'sqlite3', '~> 1.4'/m, ''

        # Add gem requirements.
        gem 'active_link_to'
        gem 'activeresource'
        gem 'acts_as_singleton'
        gem 'appsignal'
        gem 'classnames-rails'
        gem 'nokogiri'
        gem 'oj'
        gem 'pg', '~> 1.1'
        gem 'premailer-rails'
        gem 'react-rails'
        gem 'render_anywhere'
        gem 'shopify_app'
        gem 'sidekiq'
        gem 'timber', '~> 3.0'

        # Indicate which gems should only be used in production.
        gem_group :staging, :production do
          gem 'mailgun_rails'
          gem 'rails_12factor'
        end

        # Indicate which gems should only be used in development.
        gem_group :development do
          gem 'rb-readline'
          gem 'rubocop'
          gem 'rubocop-performance'
          gem 'rubocop-rails'
        end

        # Indicate which gems should only be used in development and test.
        gem_group :development, :test do
          gem 'coveralls'
          gem 'dotenv-rails'
          gem 'factory_bot_rails'
          gem 'faker'
          gem 'mechanize'
          gem 'rspec-rails'
          gem 'vcr'
          gem 'webmock'
        end

        gem_group :test do
          gem 'database_cleaner'
          gem 'shoulda-matchers'
        end
      end

      # copy template for pg configuration
      def update_database_config
        template 'config/database.yml.tt'
      end

      # Run bundle install to add our new gems before running tasks.
      def bundle_install
        Bundler.with_clean_env do
          run 'bundle install'
        end
      end

      def support_staging_environment
        copy_file 'config/environments/staging.rb', 'config/environments/staging.rb'
      end

      # Make any required adjustments to the application configuration.
      def configure_application
        # The force_ssl flag is commented by default for production.
        # Uncomment to ensure config.force_ssl = true in production.
        uncomment_lines 'config/environments/production.rb', /force_ssl/

        # Set time zone to UTC
        application "config.time_zone = 'UTC'"
        application '# Ensure UTC is the default timezone'

        # Set server side rendereing for components.js
        application <<~CONFIG
          # Enable server side react rendering
          config.react.server_renderer_options = {
            # files to load for prerendering
            files: ['components.js']
          }
        CONFIG

        # Set defaults for various charge attributes.
        application "config.x.shopify_charges_default_trial_days = 14\n"
        application 'config.x.shopify_charges_default_price = 10.00'
        application 'config.x.shopify_charges_default_type = :recurring'
        application '# Set defaults for charges created by the application'

        # Set the "real charges" config variable to false explicitly by default.
        # Only in production do we read from the environment variable and
        # potentially have it become true.
        application "config.x.shopify_charges_real = false\n"
        application '# Explicitly prevent real charges being created by default'
        application "config.x.shopify_charges_real = ENV['SHOPIFY_CHARGES_REAL'] == 'true'\n", env: :production
        application '# Allow real charges in production with an ENV variable', env: :production

        # Configure session storage.
        application "ActiveRecord::SessionStore::Session.table_name = 'disco_app_sessions'"
        application 'ActionDispatch::Session::ActiveRecordStore.session_class = DiscoApp::Session'
        application '# Configure custom session storage'

        # Set Sidekiq as the queue adapter in production.
        application "config.active_job.queue_adapter = :sidekiq\n", env: :production
        application '# Use Sidekiq as the active job backend', env: :production

        # Configure to delete X-Frame-Options so that embedded app works in iframe.
        application "config.action_dispatch.default_headers.delete('X-Frame-Options')"
        application '# Allow iframe requests'

        # Set Sidekiq as the queue adapter in staging.
        application "config.active_job.queue_adapter = :sidekiq\n", env: :staging
        application '# Use Sidekiq as the active job backend', env: :staging

        # Ensure the application configuration uses the DEFAULT_HOST environment
        # variable to set up support for reverse routing absolute URLS (needed when
        # generating Webhook URLs for example).
        application "routes.default_url_options[:host] = ENV['DEFAULT_HOST']\n"
        application '# Set the default host for absolute URL routing purposes'

        # Configure React in development, staging and production.
        application 'config.react.variant = :development', env: :development
        application '# Use development variant of React in development.', env: :development
        application 'config.react.variant = :production', env: :staging
        application '# Use production variant of React in staging.', env: :staging
        application 'config.react.variant = :production', env: :production
        application '# Use production variant of React in production.', env: :production

        # Configure ActionDispatch::HostAuthorization to be disabled
        application 'config.hosts.clear', env: :development
        application '# Disable Host Authorization middleware', env: :development

        # Configure Factory Bot as the Rails testing fixture replacement
        application <<~CONFIG
          config.generators do |g|
            g.test_framework :rspec, fixtures: true, view_specs: false, helper_specs: false, routing_specs: false
            g.fixture_replacement :factory_bot, dir: 'spec/factories'
          end
        CONFIG

        # Copy over the default puma configuration.
        copy_file 'config/puma.rb', 'config/puma.rb'

        # Mail configuration
        configuration = <<-CONFIG.strip_heredoc

            # Configure ActionMailer to use MailGun
            if ENV['MAILGUN_API_KEY']
              config.action_mailer.delivery_method = :mailgun
              config.action_mailer.mailgun_settings = {
                api_key: ENV['MAILGUN_API_KEY'],
                domain: ENV['MAILGUN_API_DOMAIN']
              }
            end
        CONFIG
        application configuration, env: :production
        application configuration, env: :staging

        # Monitoring configuration
        copy_file 'config/appsignal.yml', 'config/appsignal.yml'
      end

      # Add entries to .env and .env.local
      def add_env_variables
        configuration = <<-CONFIG.strip_heredoc

          MAILGUN_API_KEY=
          MAILGUN_API_DOMAIN=
        CONFIG
        append_to_file '.env', configuration
        append_to_file '.env.local', configuration
      end

      # Set up routes.
      def setup_routes
        route "mount DiscoApp::Engine, at: '/'"
      end

      # Run generators.
      def run_generators
        generate 'shopify_app:install'
        generate 'shopify_app:home_controller'
        rails_command 'webpacker:install'
        generate 'react:install'
      end

      def configure_rspec
        directory 'spec'
        copy_file 'root/.rspec', '.rspec'
      end

      # Copy template files to the appropriate location. In some cases, we'll be
      # overwriting or removing existing files or those created by ShopifyApp.
      def copy_and_remove_files
        # Copy initializers
        copy_file 'initializers/shopify_app.rb', 'config/initializers/shopify_app.rb'
        copy_file 'initializers/disco_app.rb', 'config/initializers/disco_app.rb'
        copy_file 'initializers/shopify_session_repository.rb', 'config/initializers/shopify_session_repository.rb'
        copy_file 'initializers/session_store.rb', 'config/initializers/session_store.rb'
        copy_file 'initializers/timber.rb', 'config/initializers/timber.rb'

        # Copy default home controller and view
        copy_file 'controllers/home_controller.rb', 'app/controllers/home_controller.rb'
        copy_file 'views/home/index.html.erb', 'app/views/home/index.html.erb'

        # Copy assets
        copy_file 'assets/stylesheets/application.scss', 'app/assets/stylesheets/application.scss'

        # Remove application.css
        remove_file 'app/assets/stylesheets/application.css'

        # Remove the layout files created by ShopifyApp
        remove_file 'app/views/layouts/application.html.erb'
        remove_file 'app/views/layouts/embedded_app.html.erb'

        # Remove the test directory generated by rails new
        remove_dir 'test'
      end

      # Copy engine migrations over.
      def install_migrations
        rake 'disco_app:install:migrations'
      end

      # Create PG database
      def create_database
        rake 'db:create'
      end

      # Run migrations.
      def migrate
        rake 'db:migrate'
      end

      # Copy package.json.
      def configure_package
        template 'root/package.json.tt', 'package.json'
      end

      def yarn_install
        run 'yarn install'
      end

      # Lock down the application to a specific Ruby version:
      #
      #  - Via .tool-versions file for asdf in development;
      #
      # This should be the last operation, to allow all other operations to run in the initial Ruby version.
      def set_ruby_version
        copy_file 'root/.tool-versions', '.tool-versions'
      end

      private

        # This method of finding the component.js manifest taken from the
        # install generator in react-rails.
        # See https://github.com/reactjs/react-rails/blob/3f0af13fa755d6e95969c17728d0354c234f3a37/lib/generators/react/install_generator.rb#L53-L55
        def components
          Pathname.new(destination_root).join('app/assets/javascripts', 'components.js')
        end

    end
  end
end
