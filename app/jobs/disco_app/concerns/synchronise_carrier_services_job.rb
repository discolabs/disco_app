module DiscoApp::Concerns::SynchroniseCarrierServicesJob
  extend ActiveSupport::Concern

  # Ensure the carrier services registered with our shop are the same as those
  # listed in our application configuration.
  def perform(shopify_domain)
    # Registered any carrier services that haven't been registered yet.
    (callback_urls - current_callback_urls).each do |callback_url|
      ShopifyAPI::CarrierService.create(
        name: carrier_service_name,
        callback_url: callback_url,
        service_discovery: true,
        format: 'json'
      )
    end

    # Remove any extraneous carrier services.
    current_carrier_services.each do |carrier_service|
      unless callback_urls.include?(carrier_service.callback_url)
        carrier_service.delete
      end
    end
  end

  protected

    def carrier_service_name
      Rails.application.config.x.shopify_app_name
    end

    def callback_urls
      []
    end

  private

    # Return a list of currently registered callback URLs.
    def current_callback_urls
      current_carrier_services.map(&:callback_url)
    end

    # Return a list of currently registered carrier services.
    def current_carrier_services
      @current_carrier_service ||= ShopifyAPI::CarrierService.find(:all)
    end

end
