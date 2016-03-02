module DiscoApp::Test
  module FileFixtures

    # Return an XML fixture as an XML string.
    def xml_fixture(path)
      filename = File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'xml', "#{path}.xml")
      File.read(filename)
    end

    # Return a JSON fixture as an indifferent hash.
    def json_fixture(path)
      filename = File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'json', "#{path}.json")
      HashWithIndifferentAccess.new(ActiveSupport::JSON.decode(File.read(filename)))
    end

    # API fixtures are special-case JSON fixtures.
    def api_fixture(path)
      filename = File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'api', "#{path}.json")
      HashWithIndifferentAccess.new(ActiveSupport::JSON.decode(File.read(filename)))
    end

    # Webhook fixtures are special-case JSON fixtures.
    def webhook_fixture(path)
      filename = File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'webhooks', "#{path}.json")
      File.read(filename)
    end

  end
end
