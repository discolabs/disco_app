require 'disco_app/support/file_fixtures'

# Make our helper modules available inside fixtures.
ActiveRecord::FixtureSet.context_class.send :include, DiscoApp::Test::FileFixtures

# Include FileFixture helpers in base TestCase class.
class ActiveSupport::TestCase

  include DiscoApp::Test::FileFixtures

end
