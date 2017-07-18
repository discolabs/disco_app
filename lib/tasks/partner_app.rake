namespace :generate do
  desc 'Generate new Shopify app from partner dashboard'
  task partner_app: :environment do
    load_partner_params = load('~/.disco_app')

    if load_partner_params
      params = {
        email: PARTNER_EMAIL.to_s,
        password: PARTNER_PASSWORD.to_s,
        organization: PARTNER_ORGANIZATION.to_s,
        app_name: ENV['SHOPIFY_APP_NAME'],
        app_url: ENV['DEFAULT_HOST'],
        embedded_app: ENV['EMBEDDED_APP'] || false,
      }

      service = DiscoApp::PartnerAppService.new(params)
      service.generate_partner_app
    end
  end
end
