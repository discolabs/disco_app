class Cart < ActiveRecord::Base
  include DiscoApp::Concerns::Synchronises

  belongs_to :shop, class_name: 'DiscoApp::Shop'

  SHOPIFY_API_CLASS = ShopifyAPI::Cart

  before_save :set_token

  def self.synchronise_by(shop, data)
    { token: data[:token] }
  end

  def total_price
    data[:line_items].map { |line_item| line_item[:line_price].to_f }.sum
  end

  private

    def set_token
      self.token = data[:token]
    end

end
