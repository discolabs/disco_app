module DiscoApp::Concerns::CanBeLiquified
  extend ActiveSupport::Concern

  SPLIT_ARRAY_SEPARATOR = '@!@'

  included do

    # Return this model as an array of Liquid {% assign %} statements.
    def as_liquid
      as_json.map { |k, v| "{% assign #{model_name.param_key}_#{k} = #{as_liquid_value(v)} %}" }
    end

    # Render this model as a series of concatenated Liquid {% assign %} statements.
    def to_liquid
      as_liquid.join("\n")
    end

    private

      # Return given value as a string expression that will be evaluated in Liquid to result in the correct value type.
      def as_liquid_value(value)
        if value.is_a? Numeric or (!!value == value)
          return value.to_s
        end
        if value.nil?
          return "nil"
        end
        if value.is_a? Array
          return "\"#{value.map { |e| (e.is_a? String) ? CGI::escapeHTML(e) : e }.join(SPLIT_ARRAY_SEPARATOR)}\" | split: \"#{SPLIT_ARRAY_SEPARATOR}\""
        end
        "\"#{CGI::escapeHTML(value.to_s)}\""
      end

  end

end
