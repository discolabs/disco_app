require 'yaml'

namespace :generate do
  desc 'Generate new Shopify app from partner dashboard'
  task partner_app: :environment do
    partner_params = YAML.load_file(File.join(ENV['HOME'], '/.disco_app.yaml'))

    if partner_params
      params = {
        email: partner_params["params"]["PARTNER_EMAIL"].to_s,
        password: partner_params["params"]["PARTNER_PASSWORD"].to_s,
        organization: partner_params["params"]["PARTNER_ORGANIZATION"].to_s,
        app_name: ENV['SHOPIFY_APP_NAME'],
        app_url: ENV['DEFAULT_HOST'],
        embedded_app: ENV['EMBEDDED_APP'] || false,
      }

      service = DiscoApp::PartnerAppService.new(params)
      service.generate_partner_app
    end
  end
end
