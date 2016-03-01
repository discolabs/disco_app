class ProxyController < ActionController::Base
  include DiscoApp::Concerns::AppProxyController

  def index
    render text: 'ok'
  end

end
