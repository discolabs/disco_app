module DiscoApp::Concerns::SynchroniseCarrierServiceJob
  extend ActiveSupport::Concern

  # Ensure that any carrier service required by our app is registered.
  def perform(_shop)
    # Don't proceed unless we have a name and callback url.
    return unless carrier_service_name and callback_url

    # Registered the carrier service if it hasn't been registered yet.
    unless current_carrier_service_names.include?(carrier_service_name)
      ShopifyAPI::CarrierService.create(
        name: carrier_service_name,
        callback_url: callback_url,
        service_discovery: true,
        format: :json
      )
    end

    # Ensure any existing carrier services (with the correct name) are active
    # and have a current callback URL.
    current_carrier_services.each do |carrier_service|
      if carrier_service.name == carrier_service_name
        carrier_service.callback_url = callback_url
        carrier_service.active = true
        carrier_service.save
      end
    end
  end

  protected

    def carrier_service_name
      DiscoApp.configuration.app_name
    end

    def callback_url
      @callback_url ||= begin
        callback_url = DiscoApp.configuration.carrier_service_callback_url
        callback_url.respond_to?('call') ? callback_url.call : callback_url
      end
    end

  private

    # Return a list of currently registered carrier service names.
    def current_carrier_service_names
      current_carrier_services.map(&:name)
    end

    # Return a list of currently registered carrier services.
    def current_carrier_services
      @current_carrier_service ||= ShopifyAPI::CarrierService.find(:all)
    end

end
