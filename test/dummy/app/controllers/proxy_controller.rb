class ProxyController < ActionController::Base

  include DiscoApp::Concerns::AppProxyController

  def index
    render plain: 'ok'
  end

end
