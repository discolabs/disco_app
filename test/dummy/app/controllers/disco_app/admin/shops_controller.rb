class DiscoApp::Admin::ShopsController < DiscoApp::Admin::ApplicationController
  include DiscoApp::Admin::Concerns::ShopsController

  def index
    render text: 'ok'
  end

end
