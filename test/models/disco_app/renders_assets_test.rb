require 'test_helper'

class DiscoApp::RendersAssetsTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @js_configuration = js_configurations(:js_swedish)
    @widget_configuration = widget_configurations(:widget_swedish)
  end

  def teardown
    @js_configuration = nil
    @widget_configuration = nil
  end

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

end
