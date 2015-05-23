require 'test_helper'
require 'generators/disco_app/disco_app_generator'

module DiscoApp
  class DiscoAppGeneratorTest < Rails::Generators::TestCase
    tests DiscoAppGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
