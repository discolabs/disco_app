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

  test 'can write product metafields, including json string type, with a single namespace with one existing metafield' do
    stub_api_request(
      :get,
      "#{@shop.admin_url}/products/#{@product.id}/metafields.json",
      'widget_store/products/get_metafields_with_existing'
    )

    stub_api_request(
      :put,
      "#{@shop.admin_url}/products/#{@product.id}.json",
      'widget_store/products/write_metafields_with_existing_single_namespace'
    )

    assert(
      @shop.with_api_context do
        @product.write_metafields(
          namespace1: {
            key1: 'value1',
            key2: {
              'json_key' => 'json_value'
            }
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

  test 'can write shop metafields with one existing metafield' do
    stub_api_request(
      :get,
      "#{@shop.admin_url}/metafields.json",
      'widget_store/shops/get_metafields_with_existing'
    )

    stub_api_request(
      :put,
      "#{@shop.admin_url}/metafields/874857827343.json",
      'widget_store/shops/write_metafields_with_existing_first'
    )

    stub_api_request(
      :post,
      "#{@shop.admin_url}/metafields.json",
      'widget_store/shops/write_metafields_with_existing_second'
    )

    assert(
      @shop.with_api_context do
        @shop.write_metafields(
          namespace1: {
            key1: 'value1',
            key2: 2
          }
        )
      end
    )
  end

end
