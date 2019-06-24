module DiscoApp::Test
  module FileFixtures

    # Return an XML fixture as an XML string.
    def xml_fixture(path)
      filename = Rails.root.join('test', 'fixtures', 'xml', "#{path}.xml")
      File.read(filename)
    end

    # Return a JSON fixture as an indifferent hash.
    def json_fixture(path, dir: 'json', parse: true)
      filename = Rails.root.join('test', 'fixtures', dir, "#{path}.json")
      return File.read(filename) unless parse

      HashWithIndifferentAccess.new(JSON.parse(File.read(filename)))
    end

    # Webhook fixtures are special-case JSON fixtures.
    def webhook_fixture(path, parse: true)
      json_fixture(path, dir: 'webhooks', parse: parse)
    end

  end
end
