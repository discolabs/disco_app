class DiscoAppGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  # Copy a number of template files to the top-level directory of our application:
  #
  #  - .env and .env.sample for settings environment variables in development with dotenv-rails;
  #  - Slightly customised version of the default Rails .gitignore;
  #  - Default simple Procfile for Heroku.
  #
  def copy_root_files
    %w(.env .env.sample .gitignore Procfile).each do |file|
      copy_file "root/#{file}", file
    end
  end

  # Configure the application's Gemfile.
  def configure_gems
    # Remove sqlite from the general Gemfile.
    gsub_file 'Gemfile', /^# Use sqlite3 as the database for Active Record\ngem 'sqlite3'/m, ''

    # Add gems common to all environments.
    gem 'sidekiq', '~> 3.3.4'
    gem 'puma', '~> 2.11.3'

    # Add gems for development and testing only.
    gem_group :development, :test do
      gem 'sqlite3', '~> 1.3.10'
      gem 'dotenv-rails', '~> 2.0.1'
    end

    # Add gems for production only.
    gem_group :production do
      gem 'pg', '~> 0.18.2'
      gem 'rails_12factor', '~> 0.0.3'
    end
  end

  # Lock down the application to a specific Ruby version:
  #
  #  - Via .ruby-version file for rbenv in development;
  #  - Via a Gemfile line in production.
  #
  def set_ruby_version
    copy_file 'root/.ruby-version', '.ruby-version'
    prepend_to_file 'Gemfile', "ruby '2.2.2'\n"
  end

end
