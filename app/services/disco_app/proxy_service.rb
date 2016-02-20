class DiscoApp::ProxyService

  # Return true iff the signature provided in the given query string matches
  # that calculated from the remaining query parameters and the given secret.
  def self.proxy_signature_is_valid?(query_string, secret)
    query_hash = Rack::Utils.parse_query(query_string)
    signature = query_hash.delete('signature').to_s
    ActiveSupport::SecurityUtils.variable_size_secure_compare(self.calculated_signature(query_hash, secret), signature)
  end

  # Return the calculated signature for the given query hash and secret.
  def self.calculated_signature(query_hash, secret)
    sorted_params = query_hash.collect{ |k, v| "#{k}=#{Array(v).join(',')}" }.sort.join
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, sorted_params)
  end

end
