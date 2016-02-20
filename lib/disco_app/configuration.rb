module DiscoApp

  class Configuration

    # Required configuration.
    attr_accessor :app_name

    # Set the below if using an application proxy.
    attr_accessor :app_proxy_prefix

    # Optional configuration, usually useful for development environments.
    attr_accessor :skip_proxy_verification
    alias_method  :skip_proxy_verification?, :skip_proxy_verification
    attr_accessor :skip_webhook_verification
    alias_method  :skip_webhook_verification?, :skip_webhook_verification
    attr_accessor :skip_carrier_request_verification
    alias_method  :skip_carrier_request_verification?, :skip_carrier_request_verification

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
