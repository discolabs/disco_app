namespace :generate do
  desc "Create Rollbar project for current shopify app, and return the ROLLBAR API TOKEN"
  task rollbar_project: :environment do
    project_access_token = DiscoApp::RollbarClient.instance.create_project(ENV['APP_NAME'])
    puts '#' * 80
    puts 'New Rollbar project successfully created!'
    puts "ROLLBAR_ACCESS_TOKEN = #{project_access_token}"
    puts '#' * 80
  end
end
