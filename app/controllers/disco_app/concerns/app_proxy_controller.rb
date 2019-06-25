module DiscoApp::Concerns::AppProxyController

  extend ActiveSupport::Concern

  included do
    before_action :verify_proxy_signature
    before_action :shopify_shop
    after_action :add_liquid_header

    rescue_from ActiveRecord::RecordNotFound do |_exception|
      render_error 404
    end
  end

  private

    def verify_proxy_signature
      head :unauthorized unless proxy_signature_is_valid?
    end

    def proxy_signature_is_valid?
      return true if (Rails.env.development? || Rails.env.test?) && DiscoApp.configuration.skip_proxy_verification?

      DiscoApp::ProxyService.proxy_signature_is_valid?(request.query_string, ShopifyApp.configuration.secret)
    end

    def shopify_shop
      @shop = DiscoApp::Shop.find_by_shopify_domain!(params[:shop])
    end

    def add_liquid_header
      response.headers['Content-Type'] = 'application/liquid'
    end

    def render_error(status)
      add_liquid_header
      render "disco_app/proxy_errors/#{status}", status: status
    end

end
