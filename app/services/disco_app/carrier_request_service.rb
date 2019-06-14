class DiscoApp::CarrierRequestService

  # Return true iff the provided hmac_to_verify matches that calculated from the
  # given data and secret.
  def self.is_valid_hmac?(body, secret, hmac_to_verify)
    ActiveSupport::SecurityUtils.secure_compare(calculated_hmac(body, secret), hmac_to_verify.to_s)
  end

  # Calculate the HMAC for the given data and secret.
  def self.calculated_hmac(body, secret)
    digest = OpenSSL::Digest.new('sha256')
    Base64.encode64(OpenSSL::HMAC.digest(digest, secret, body)).strip
  end

end
