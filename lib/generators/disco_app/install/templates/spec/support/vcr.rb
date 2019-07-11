VCR.configure do |config|
  config.before_record do |interaction|
    interaction.request.headers['X-Shopify-Access-Token'] = ['<REDACTED>']
    interaction.request.headers['Authorization'] = ['<REDACTED>']
  end
  config.cassette_library_dir = 'spec/vcr'
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    decode_compressed_response: true,
    match_requests_on: %i[method uri body],
    record: :once
  }
  config.hook_into :webmock
end
