require 'test_helper'

module DiscoApp
  class SynchroniseResourcesServiceTest < ActiveSupport::TestCase

    include ActiveJob::TestHelper

    def setup
      @shop = disco_app_shops(:widget_store)
    end

    def teardown
      @shop = nil
    end

    test 'synchronising all Products' do
      assert_difference 'Product.count', 4 do
        VCR.use_cassette('synchronise_products') do
          DiscoApp::SynchroniseResourcesService.synchronise_all(@shop, 'Product')
        end
      end
    end

    test 'synchronising all Products from since_id' do
      assert_difference 'Product.count', 2 do
        VCR.use_cassette('synchronise_products_since_id') do
          DiscoApp::SynchroniseResourcesService.synchronise_all(@shop, 'Product', 95476870)
        end
      end
    end
      
    test 'synchronising all Products with pagination enques job with since id' do
      assert_difference 'Product.count', 2 do
        VCR.use_cassette('synchronise_products_paginated') do
          DiscoApp::SynchroniseResourcesService.stub_const(:PAGE_LIMIT, 2) do
            DiscoApp::SynchroniseResourcesService.synchronise_all(@shop, 'Product')
          end
        end
      end

      assert_enqueued_with(
        job: DiscoApp::SynchroniseResourcesJob, args: [@shop, 'Product', 5476870]
      )
    end

  end
end
