require 'test_helper'

class ActiveRecord::SessionStore::SessionTest < ActiveSupport::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
    @session = ActiveRecord::SessionStore::Session.new(
      session_id: 'a91bfc51fa79c9d09d43e2615d9345d4',
      data: {
        'shopify' => @shop.id,
        'shopify_domain' => @shop.shopify_domain
      }
    )
  end

  test 'logged in sessions are stored linked to the shopify domain' do
    @session.save!
    assert_equal 'widgets.myshopify.com', @session.shopify_domain
  end

end
