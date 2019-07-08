class DiscoAppGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  # Copy a number of template files to the top-level directory of our application:
  #
  #  - .env and .env.local for settings environment variables in development with dotenv-rails;
  #  - Slightly customised version of the default Rails .gitignore;
  #  - Default simple Procfile for Heroku;
  #  - .editorconfig to help enforce 2-space tabs, newlines and truncated whitespace for editors that support it.
  #  - README/PULL REQUEST template
  #
  def copy_root_files
    %w(.editorconfig .env .env.local .gitignore .rubocop.yml .codeclimate.yml Procfile CHECKS README.md).each do |file|
      copy_file "root/#{file}", file
    end
    directory 'root/.github'
  end

  # Remove a number of root files.
  def remove_root_files
    %w(README.rdoc).each do |file|
      remove_file file
    end
  end

  # Configure the application's Gemfile.
  def configure_gemfile
    # Remove sqlite.
    gsub_file 'Gemfile', /^# Use sqlite3 as the database for Active Record\ngem 'sqlite3'/m, ''

    # Add gem requirements.
    gem 'active_link_to'
    gem 'activeresource'
    gem 'acts_as_singleton'
    gem 'classnames-rails'
    gem 'newrelic_rpm'
    gem 'nokogiri'
    gem 'oj'
    gem 'pg'
    gem 'premailer-rails'
    gem 'react-rails'
    gem 'appsignal'
    gem 'shopify_app'
    gem 'sidekiq'

    # Indicate which gems should only be used in staging and production.
    gem_group :staging, :production do
      gem 'mailgun_rails'
      gem 'rails_12factor'
    end

    # Indicate which gems should only be used in development and test.
    gem_group :development, :test do
      gem 'dotenv-rails'
      gem 'mechanize'
      gem 'minitest-reporters'
      gem 'webmock'
    end
  end

  # copy template for pg configuration
  def update_database_config
    template 'config/database.yml.tt'
  end

  def update_cable_config
    template 'config/cable.yml.tt'
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
    application "# Ensure UTC is the default timezone"

    # Set server side rendereing for components.js
    application "config.react.server_renderer_options = {\nfiles: ['components.js'], # files to load for prerendering\n}"
    application "# Enable server side react rendering"

    # Set defaults for various charge attributes.
    application "config.x.shopify_charges_default_trial_days = 14\n"
    application "config.x.shopify_charges_default_price = 10.00"
    application "config.x.shopify_charges_default_type = :recurring"
    application "# Set defaults for charges created by the application"

    # Set the "real charges" config variable to false explicitly by default.
    # Only in production do we read from the environment variable and
    # potentially have it become true.
    application "config.x.shopify_charges_real = false\n"
    application "# Explicitly prevent real charges being created by default"
    application "config.x.shopify_charges_real = ENV['SHOPIFY_CHARGES_REAL'] == 'true'\n", env: :production
    application "# Allow real charges in production with an ENV variable", env: :production

    # Configure session storage.
    application "ActiveRecord::SessionStore::Session.table_name = 'disco_app_sessions'"
    application "ActionDispatch::Session::ActiveRecordStore.session_class = DiscoApp::Session"
    application "# Configure custom session storage"

    # Set Sidekiq as the queue adapter in production.
    application "config.active_job.queue_adapter = :sidekiq\n", env: :production
    application "# Use Sidekiq as the active job backend", env: :production

    # Set Sidekiq as the queue adapter in staging.
    application "config.active_job.queue_adapter = :sidekiq\n", env: :staging
    application "# Use Sidekiq as the active job backend", env: :staging

    # Ensure the application configuration uses the DEFAULT_HOST environment
    # variable to set up support for reverse routing absolute URLS (needed when
    # generating Webhook URLs for example).
    application "routes.default_url_options[:host] = ENV['DEFAULT_HOST']\n"
    application "# Set the default host for absolute URL routing purposes"

    # Configure React in development, staging, and production.
    application "config.react.variant = :development", env: :development
    application "# Use development variant of React in development.", env: :development

    application "config.react.variant = :production", env: :staging
    application "# Use production variant of React in staging.", env: :staging

    application "config.react.variant = :production", env: :production
    application "# Use production variant of React in production.", env: :production

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
    copy_file 'config/newrelic.yml', 'config/newrelic.yml'
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
    generate 'react:install'
  end

  # Copy template files to the appropriate location. In some cases, we'll be
  # overwriting or removing existing files or those created by ShopifyApp.
  def copy_and_remove_files
    # Copy initializers
    copy_file 'initializers/shopify_app.rb', 'config/initializers/shopify_app.rb'
    copy_file 'initializers/disco_app.rb', 'config/initializers/disco_app.rb'
    copy_file 'initializers/shopify_session_repository.rb', 'config/initializers/shopify_session_repository.rb'
    copy_file 'initializers/session_store.rb', 'config/initializers/session_store.rb'

    # Copy default home controller and view
    copy_file 'controllers/home_controller.rb', 'app/controllers/home_controller.rb'
    copy_file 'views/home/index.html.erb', 'app/views/home/index.html.erb'

    # Copy assets
    copy_file 'assets/javascripts/application.js', 'app/assets/javascripts/application.js'
    copy_file 'assets/javascripts/components.js', 'app/assets/javascripts/components.js'
    copy_file 'assets/stylesheets/application.scss', 'app/assets/stylesheets/application.scss'

    # Remove application.css
    remove_file 'app/assets/stylesheets/application.css'

    # Remove the layout files created by ShopifyApp
    remove_file 'app/views/layouts/application.html.erb'
    remove_file 'app/views/layouts/embedded_app.html.erb'
  end

  # Add the Disco App test helper to test/test_helper.rb
  def add_test_helper
    inject_into_file 'test/test_helper.rb', "require 'disco_app/test_help'\n", { after: "require 'rails/test_help'\n" }
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

  # Lock down the application to a specific Ruby version:
  #
  #  - Via .ruby-version file for rbenv in development;
  #  - Via a Gemfile line in production.
  #
  # This should be the last operation, to allow all other operations to run in the initial Ruby version.
  def set_ruby_version
    copy_file 'root/.ruby-version', '.ruby-version'
    prepend_to_file 'Gemfile', "ruby '2.6.3'\n"
  end

  private

    # This method of finding the component.js manifest taken from the
    # install generator in react-rails.
    # See https://github.com/reactjs/react-rails/blob/3f0af13fa755d6e95969c17728d0354c234f3a37/lib/generators/react/install_generator.rb#L53-L55
    def components
      Pathname.new(destination_root).join('app/assets/javascripts', 'components.js')
    end

end
