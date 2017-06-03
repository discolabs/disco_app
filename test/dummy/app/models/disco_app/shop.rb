require 'active_utils'

class DiscoApp::Shop < ActiveRecord::Base
  include DiscoApp::Concerns::Shop

  has_one :js_configuration
  has_one :widget_configuration
  has_many :carts
  has_many :products

  # Extend the Shop model to return the Shop's country as an ActiveUtils country.
  def country
    begin
      ActiveUtils::Country.find(data[:country_name])
    rescue ActiveUtils::InvalidCountryCodeError
      nil
    end
  end

end
