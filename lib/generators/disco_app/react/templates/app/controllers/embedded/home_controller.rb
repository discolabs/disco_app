module Embedded
  class HomeController < ApplicationController

    include DiscoApp::Concerns::AuthenticatedController
    include DiscoApp::Concerns::UserAuthenticatedController

    layout 'embedded'

    def index
    end

  end
end
