require 'test_helper'

class DiscoApp::CanBeLiquifiedTest < ActiveSupport::TestCase

  class Model
    include ActiveModel::Model
    include DiscoApp::Concerns::CanBeLiquified

    def initialize(attributes = {})
      @attributes = attributes
    end

    def as_json
      @attributes.as_json
    end

    def liquid_model_name
      'model'
    end
  end

  def setup
    @model = Model.new(
      numeric: 42,
      boolean: true,
      empty: nil,
      string: "The cat's pyjamas are \"great\".",
      string_html: "The cat's pyjamas are <strong style=\"color: red;\">great</strong>.",
      array_of_numerics: [1, 2, 3],
      array_of_strings: ['A', 'B', 'C'],
      hash: {}
    )
  end

  def teardown
    @model = nil
  end

  ##
  # Test Liquid output.
  ##

  test 'correct liquid is output for model' do
    assert_equal liquid_fixture('model.liquid'), @model.to_liquid
  end

  private

    # Return an asset fixture as a string.
    def liquid_fixture(path)
      filename = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'fixtures', 'liquid', "#{path}")
      File.read(filename).strip
    end

end
