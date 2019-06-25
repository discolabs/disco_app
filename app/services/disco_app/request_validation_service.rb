class DiscoApp::RequestValidationService

  def self.hmac_valid?(query_string, secret)
    query_hash = Rack::Utils.parse_query(query_string)
    hmac = query_hash.delete('hmac').to_s
    ActiveSupport::SecurityUtils.secure_compare(calculated_hmac(query_hash, secret), hmac)
  end

  # Return the calculated hmac for the given query hash and secret.
  def self.calculated_hmac(query_hash, secret)
    sorted_params = query_hash.map{ |k, v| "#{k}=#{Array(v).join(',')}" }.sort.join('&')
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, sorted_params)
  end

end
