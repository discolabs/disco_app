class DiscoApp::WebhookService

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

  # Try to find a job class for the given webhook topic.
  def self.find_job_class(topic)
    # First try to find a top-level matching job class.
    "#{topic}_job".gsub('/', '_').classify.constantize
  rescue NameError
    # If that fails, try to find a DiscoApp:: prefixed job class.
    begin
      %(DiscoApp::#{"#{topic}_job".gsub('/', '_').classify}).constantize
    rescue NameError
      nil
    end
  end

end
