module DiscoApp

  class Configuration

    # Required configuration.
    attr_accessor :app_name

    # Set the list of Shopify webhook topics to register.
    attr_accessor :webhook_topics

    # Set the below if using an application proxy.
    attr_accessor :app_proxy_prefix

    # Set the below to create real Shopify charges.
    attr_accessor :real_charges
    alias_method  :real_charges?, :real_charges

    # Optional configuration, usually useful for development environments.
    attr_accessor :skip_proxy_verification
    alias_method  :skip_proxy_verification?, :skip_proxy_verification
    attr_accessor :skip_webhook_verification
    alias_method  :skip_webhook_verification?, :skip_webhook_verification
    attr_accessor :skip_carrier_request_verification
    alias_method  :skip_carrier_request_verification?, :skip_carrier_request_verification
    attr_accessor :skip_oauth
    alias_method  :skip_oauth?, :skip_oauth

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
