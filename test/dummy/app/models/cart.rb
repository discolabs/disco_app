class Cart < ApplicationRecord

  include DiscoApp::Concerns::Synchronises

  SHOPIFY_API_CLASS = ShopifyAPI::Cart

  belongs_to :shop, class_name: 'DiscoApp::Shop'

  before_save :set_token

  def self.synchronise_by(_shop, data)
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
