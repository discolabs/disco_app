require 'yaml'

namespace :generate do
  desc "Create Rollbar project for current shopify app, and return the ROLLBAR API TOKEN"
  task rollbar_project: :environment do
    begin
      config_path = File.join(ENV['HOME'], '.disco_app.yml')
      config = YAML.load_file(config_path)
    rescue StandardError
      abort("Could not load configuration file from #{config_path}, aborting.")
    end

    params = {
      write_account_access_token: config['params']['ROLLBAR_ACCOUNT_ACCESS_TOKEN_WRITE'].to_s,
      read_account_access_token: config['params']['ROLLBAR_ACCOUNT_ACCESS_TOKEN_READ'].to_s
    }

    project_access_token = DiscoApp::RollbarClient.new(params).create_project(ENV['APP_NAME'].blank? ? ENV['SHOPIFY_APP_NAME'] : ENV['APP_NAME'])
    puts '#' * 80
    puts 'New Rollbar project successfully created!'
    puts "ROLLBAR_ACCESS_TOKEN = #{project_access_token}"
    puts '#' * 80
  end
end
