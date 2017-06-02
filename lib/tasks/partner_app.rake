namespace :generate do
  desc "Generate new Shopify app from partner dashboard"
  task :partner_app => :environment do
    service = DiscoApp::PartnerAppService.new(
      ENV['PARTNER_EMAIL'],
      ENV['PARTNER_PASSWORD'],
      ENV['PARTNER_ORGANIZATION'],
      ENV['SHOPIFY_APP_NAME'],
      ENV['DEFAULT_HOST'],
      ENV['EMBEDDED_APP']
    )
    service.generate_partner_app
  end
end
