class HomeController < ApplicationController

  include DiscoApp::Concerns::AuthenticatedController

  def index
  end

end
