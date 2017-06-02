namespace :generate do
  desc 'Generate new Shopify app from partner dashboard'
  task partner_app: :environment do
    params = {
      email: ENV['PARTNER_EMAIL'],
      password: ENV['PARTNER_PASSWORD'],
      organization: ENV['PARTNER_ORGANIZATION'],
      app_name: ENV['SHOPIFY_APP_NAME'],
      app_url: ENV['DEFAULT_HOST'],
      embedded_app: ENV['EMBEDDED_APP'] || false,
    }

    service = DiscoApp::PartnerAppService.new(params)
    service.generate_partner_app
  end
end
