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

  test 'rendering of javascript asset queued when model saved' do
    assert_enqueued_with(job: DiscoApp::RenderAssetsJob) do
      @js_configuration.update(locale: :no)
    end
  end

  test 'rendering of javascript asset not queued when model saved without triggering changes' do
    assert_no_enqueued_jobs do
      @js_configuration.update(label: 'Sample')
    end
  end

end
