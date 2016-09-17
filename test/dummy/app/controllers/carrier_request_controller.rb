class CarrierRequestController < ActionController::Base
  include DiscoApp::Concerns::CarrierRequestController

  def rates
    render json: {
      rates: []
    }
  end

end
