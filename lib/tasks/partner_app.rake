require 'yaml'

namespace :generate do
  desc 'Generate new Shopify app from partner dashboard'
  task partner_app: :environment do
    begin
      config_path = File.join(ENV['HOME'], '.disco_app.yml')
      config = YAML.load_file(config_path)
    rescue StandardError => e
      abort("Could not load configuration file from #{config_path}, aborting.")
    end

    if config
      params = {
        email: config['params']['PARTNER_EMAIL'].to_s,
        password: config['params']['PARTNER_PASSWORD'].to_s,
        organization: config['params']['PARTNER_ORGANIZATION'].to_s,
        app_name: ENV['SHOPIFY_APP_NAME'],
        app_url: ENV['DEFAULT_HOST']
      }

      service = DiscoApp::PartnerAppService.new(params)
      service.generate_partner_app
    end
  end
end
