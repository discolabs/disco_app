class DiscoApp::Admin::ShopsController < DiscoApp::Admin::ApplicationController

  include DiscoApp::Admin::Concerns::ShopsController

  def index
    render plain: 'ok'
  end

end
