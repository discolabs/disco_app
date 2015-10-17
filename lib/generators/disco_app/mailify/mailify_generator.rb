module DiscoApp
  module Generators
    class MailifyGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      # Install the react-rails gem and run its setup.
      def install_gem
        # Add premailer gem to Gemfile.
        gem 'premailer-rails', '~> 1.8.2'

        # Add explicit dependency on Nokogiri
        gem 'nokogiri', '~> 1.6.6.1'

        # Add the Mailgun rails gem (production only)
        gem_group :production do
          gem 'mailgun_rails', '~> 0.7.0'
        end

        # Install gem.
        Bundler.with_clean_env do
          run 'bundle install'
        end
      end

      # Set application configuration
      def configure_application
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
      end

      # Add entries to .env and .env.sample
      def add_env_variables
        configuration = <<-CONFIG.strip_heredoc

          MAILGUN_API_KEY=
          MAILGUN_API_DOMAIN=
        CONFIG
        append_to_file '.env', configuration
        append_to_file '.env.sample', configuration
      end

    end
  end
end
