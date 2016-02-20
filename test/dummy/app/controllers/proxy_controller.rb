class ProxyController < ActionController::Base
  include DiscoApp::AppProxyController

  def index
    render text: 'ok'
  end

end
