require 'test_helper'

class DiscoApp::SessionTest < ActiveSupport::TestCase

  def setup
    @shop = disco_app_shops(:widget_store)
    @session = DiscoApp::Session.create(
      session_id: 'a91bfc51fa79c9d09d43e2615d9345d4',
      data: {
        shopify: @shop.id,
        shopify_domain: @shop.shopify_domain
      }
    )
  end

  test 'logged in sessions are linked to their shop' do
    assert_equal @shop.id, @session.shop_id
  end

  test 'can fetch sessions for a particular shop through association' do
    assert_equal 1, @shop.sessions.size
  end

  test 'sessions can be deleted by shop' do
    DiscoApp::Session.create(session_id: 'a91bfc51fa79c9d09d43e2615d9345d5', data: {})
    assert_equal 2, DiscoApp::Session.count
    @shop.sessions.delete_all
    assert_equal 1, DiscoApp::Session.count
  end

end
