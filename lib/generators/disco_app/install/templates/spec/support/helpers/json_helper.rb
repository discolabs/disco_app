module Helpers
  module JsonHelper

    # Return a JSON fixture as an indifferent hash.
    def json_fixture(path, dir: 'json', parse: true)
      filename = Rails.root.join('spec', 'fixtures', 'files', dir, "#{path}.json")
      return File.read(filename) unless parse

      HashWithIndifferentAccess.new(ActiveSupport::JSON.decode(File.read(filename)))
    end

  end
end
