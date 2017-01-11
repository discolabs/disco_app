class DiscoAppGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  # Copy a number of template files to the top-level directory of our application:
  #
  #  - .env and .env.local for settings environment variables in development with dotenv-rails;
  #  - Slightly customised version of the default Rails .gitignore;
  #  - Default simple Procfile for Heroku.
  #
  def copy_root_files
    %w(.env .env.local .gitignore Procfile CHECKS).each do |file|
      copy_file "root/#{file}", file
    end
  end

  # Remove a number of root files.
  def remove_root_files
    %w(README.rdoc).each do |file|
      remove_file file
    end
  end

  # Configure the application's Gemfile.
  def configure_gems
    # Remove sqlite from the general Gemfile.
    gsub_file 'Gemfile', /^# Use sqlite3 as the database for Active Record\ngem 'sqlite3'/m, ''

    # Add gems common to all environments.
    gem 'shopify_app', '~> 6.4.1'
    gem 'sidekiq', '~> 4.0.2'
    gem 'puma', '~> 2.14.0'
    gem 'activerecord-session_store', '~> 1.0.0'
    gem 'activeresource', github: 'shopify/activeresource', tag: '4.2-threadsafe'
    gem 'rails-bigint-pk', '~> 1.2.0'
    gem 'acts_as_singleton', '~> 0.0.8'
    gem 'pg', '~> 0.18.3'
    gem 'react-rails', '~> 1.10'
    gem 'classnames-rails', '~> 2.1.5'
    gem 'active_link_to', '~> 1.0.2'
    gem 'premailer-rails', '~> 1.8.2'
    gem 'nokogiri', '~> 1.6.8'
    gem 'render_anywhere', '~> 0.0.12', require: false

    # Add gems for development and testing only.
    gem_group :development, :test do
      gem 'dotenv-rails', '~> 2.0.2'
      gem 'minitest-reporters', '~> 1.0.19'
      gem 'guard', '~> 2.13.0'
      gem 'guard-minitest', '~> 2.4.4'
    end

    # Add gems for production only.
    gem_group :production do
      gem 'rails_12factor', '~> 0.0.3'
      gem 'mailgun_rails', '~> 0.7.0'
    end

    # Add monitoring gems to Gemfile
    gem 'rollbar', '~> 2.8.0'
    gem 'oj', '~> 2.14.5'
    gem 'newrelic_rpm', '~> 3.15.2.317'
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

    # Ensure the application configuration uses the DEFAULT_HOST environment
    # variable to set up support for reverse routing absolute URLS (needed when
    # generating Webhook URLs for example).
    application "routes.default_url_options[:host] = ENV['DEFAULT_HOST']\n"
    application "# Set the default host for absolute URL routing purposes"

    # Configure React in development and production.
    application "config.react.variant = :development", env: :development
    application "# Use development variant of React in development.", env: :development
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

    # Monitoring configuration
    copy_file 'initializers/rollbar.rb', 'config/initializers/rollbar.rb'
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
    generate 'bigint_pk:install'
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
    prepend_to_file 'Gemfile', "ruby '2.3.3'\n"
  end

  private

    # This method of finding the component.js manifest taken from the
    # install generator in react-rails.
    # See https://github.com/reactjs/react-rails/blob/3f0af13fa755d6e95969c17728d0354c234f3a37/lib/generators/react/install_generator.rb#L53-L55
    def components
      Pathname.new(destination_root).join('app/assets/javascripts', 'components.js')
    end

end
