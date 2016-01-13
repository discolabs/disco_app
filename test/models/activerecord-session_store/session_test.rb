require 'test_helper'

class ActiveRecord::SessionStore::SessionTest < ActiveSupport::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
    @session = ActiveRecord::SessionStore::Session.create(
      session_id: 'a91bfc51fa79c9d09d43e2615d9345d4',
      data: {
        'shopify' => @shop.id,
        'shopify_domain' => @shop.shopify_domain
      }
    )
  end

  test 'logged in sessions are stored linked to the shopify domain' do
    assert_equal 'widgets.myshopify.com', @session.shopify_domain
  end

  test 'sessions can be deleted by shopify domain' do
    ActiveRecord::SessionStore::Session.create(session_id: 'a91bfc51fa79c9d09d43e2615d9345d5', data: {})
    assert_equal 2, ActiveRecord::SessionStore::Session.count
    ActiveRecord::SessionStore::Session.where(shopify_domain: 'widgets.myshopify.com').delete_all
    assert_equal 1, ActiveRecord::SessionStore::Session.count
  end

end
