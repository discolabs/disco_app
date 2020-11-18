require 'test_helper'

class DiscoApp::HasMetafieldsTest < ActiveSupport::TestCase

  include DiscoApp::Test::ShopifyAPI

  def setup
    @product = products(:ipod)
    @shop = @product.shop
  end

  def teardown
    @product = nil
    @shop = nil
  end

  test 'can write product metafields with a single namespace with no existing metafields' do
    stub_api_request(
      :get,
      "#{@shop.admin_url}/products/#{@product.id}/metafields.json",
      'widget_store/products/get_metafields_empty'
    )

    stub_api_request(
      :put,
      "#{@shop.admin_url}/products/#{@product.id}.json",
      'widget_store/products/write_metafields_single_namespace'
    )

    assert(
      @shop.with_api_context do
        @product.write_metafields(
          namespace1: {
            key1: 'value1',
            key2: 2
          }
        )
      end
    )
  end

  test 'can write product metafields with multiple namespaces with no existing metafields' do
    stub_api_request(
      :get,
      "#{@shop.admin_url}/products/#{@product.id}/metafields.json",
      'widget_store/products/get_metafields_empty'
    )

    stub_api_request(
      :put,
      "#{@shop.admin_url}/products/#{@product.id}.json",
      'widget_store/products/write_metafields_multiple_namespaces'
    )

    assert(
      @shop.with_api_context do
        @product.write_metafields(
          namespace1: {
            n1key1: 'value1',
            n1key2: 2
          },
          namespace2: {
            n2key3: 'value3',
            n2key4: 2
          }
        )
      end
    )
  end

end
