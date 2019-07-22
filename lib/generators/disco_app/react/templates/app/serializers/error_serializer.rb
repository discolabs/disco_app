class ErrorSerializer

  attr_reader :errors, :source, :title

  def initialize(errors, source: nil, title: nil)
    @errors = errors
    @source = source
    @title = title
  end

  def serialized_json
    serializable_hash.to_json
  end

  def serializable_hash
    {
      errors: formatted_errors
    }
  end

  private

    def formatted_errors
      return errors_from_exception if exception_error?
      return errors_from_string if string_error?

      errors_from_active_model
    end

    def errors_from_active_model
      error_array = []

      errors.keys.each do |field|
        errors.full_messages_for(field).each do |error|
          error_array << {
            source: { pointer: "/data/attributes/#{field}" },
            title: title || 'Unprocessable entity',
            detail: error
          }
        end
      end

      error_array
    end

    def errors_from_exception
      error = {
        title: title || errors.class.name.demodulize || 'Unknown error',
        detail: errors.message
      }

      error[:source] = { pointer: source } if source

      [error]
    end

    def errors_from_string
      error = {
        title: title || 'Unknown error',
        detail: errors
      }

      error[:source] = { pointer: source } if source

      [error]
    end

    def exception_error?
      errors.is_a?(StandardError)
    end

    def string_error?
      errors.is_a?(String)
    end

end
