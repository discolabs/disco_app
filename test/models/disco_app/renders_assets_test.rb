require 'test_helper'

class DiscoApp::RendersAssetsTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include DiscoApp::Test::ShopifyAPI

  def setup
    @shop = disco_app_shops(:widget_store)
    @js_configuration = js_configurations(:js_swedish)
    @widget_configuration = widget_configurations(:widget_swedish)
  end

  def teardown
    @shop = nil
    @js_configuration = nil
    @widget_configuration = nil
  end

  ##
  # Test queueing behaviour.
  ##

  test 'rendering of javascript asset group queued when locale changed' do
    assert_enqueued_with(job: DiscoApp::RenderAssetGroupJob) do
      @js_configuration.update(locale: :no)
    end
  end

  test 'rendering of javascript asset group not queued when label changed' do
    assert_no_enqueued_jobs do
      @js_configuration.update(label: 'Sample')
    end
  end

  test 'rendering of widget asset group queued when locale changed' do
    assert_enqueued_with(job: DiscoApp::RenderAssetGroupJob, args: [@widget_configuration.shop, @widget_configuration, 'widget_assets']) do
      @widget_configuration.update(locale: :no)
    end
  end

  test 'rendering of liquid asset group queued when locale changed' do
    assert_enqueued_with(job: DiscoApp::RenderAssetGroupJob, args: [@widget_configuration.shop, @widget_configuration, 'liquid_assets']) do
      @widget_configuration.update(locale: :no)
    end
  end

  test 'rendering of widget asset group queued when background color changed' do
    assert_enqueued_with(job: DiscoApp::RenderAssetGroupJob, args: [@widget_configuration.shop, @widget_configuration, 'widget_assets']) do
      @widget_configuration.update(background_color: '#FF0000')
    end
  end

  test 'rendering of liquid asset group not queued when background color changed' do
    assert_enqueued_jobs 1 do
      @widget_configuration.update(background_color: '#FF0000')
    end
  end

  ##
  # Test rendering behaviour.
  ##

  test 'individual js asset renders correctly' do
    assert_equal asset_fixture('test.js'), @js_configuration.send('render_asset_group_asset', 'test.js', {})
  end

  test 'js asset group renders and uploads to shopify' do
    stub_api_request(:put, "#{@shop.admin_url}/assets.json", 'widget_store/assets/create_test_js')
    @js_configuration.render_asset_group(:js_assets)
  end

  test 'widget asset group renders and uploads to shopify' do
    stub_api_request(:put, "#{@shop.admin_url}/assets.json", 'widget_store/assets/create_widget_scss')
    stub_api_request(:put, "#{@shop.admin_url}/assets.json", 'widget_store/assets/create_widget_js')
    @widget_configuration.render_asset_group(:widget_assets)
  end

  private

    # Return an asset fixture as a string.
    def asset_fixture(path)
      filename = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'fixtures', 'assets', "#{path}")
      File.read(filename)
    end

end
