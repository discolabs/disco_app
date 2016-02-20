module DiscoApp

  class Configuration

    # Disco App settings.
    attr_accessor :skip_proxy_verification
    alias_method  :skip_proxy_verification?, :skip_proxy_verification
    attr_accessor :skip_webhook_verification
    alias_method  :skip_webhook_verification?, :skip_webhook_verification
    attr_accessor :skip_carrier_request_verification
    alias_method  :skip_carrier_request_verification?, :skip_carrier_request_verification

    def initialize
      @skip_proxy_verification = false
      @skip_webhook_verification = false
      @skip_carrier_request_verification = false
    end

  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end

end
