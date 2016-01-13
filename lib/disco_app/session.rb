class DiscoApp::Session < ActiveRecord::SessionStore::Session

  before_save :set_shop_id!

  private

    def set_shop_id!
      return false unless loaded?
      write_attribute(:shop_id, data[:shopify] || data['shopify'])
    end

end
