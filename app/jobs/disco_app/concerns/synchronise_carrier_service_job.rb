module DiscoApp::Concerns::SynchroniseCarrierServiceJob
  extend ActiveSupport::Concern

  # Ensure that any carrier service required by our app is registered.
  def perform(shopify_domain)
    # Don't proceed unless we have a name and callback url.
    return unless carrier_service_name and callback_url

    # Don't proceed if the carrier service is already registered.
    return if current_carrier_service_names.include?(carrier_service_name)

    # Otherwise, register the carrier service.
    ShopifyAPI::CarrierService.create(
      name: carrier_service_name,
      callback_url: callback_url,
      service_discovery: true,
      format: 'json'
    )

    # De-activate and extraneous carrier services.
    current_carrier_services.each do |carrier_service|
      unless carrier_service.name == carrier_service_name
        carrier_service.active = false
        carrier_service.save
      end
    end
  end

  protected

    def carrier_service_name
      Rails.application.config.x.shopify_app_name
    end

    def callback_url
      nil
    end

  private

    # Return a list of currently registered callback URLs.
    def current_carrier_service_names
      current_carrier_services.map(&:name)
    end

    # Return a list of currently registered carrier services.
    def current_carrier_services
      @current_carrier_service ||= ShopifyAPI::CarrierService.find(:all)
    end

end
