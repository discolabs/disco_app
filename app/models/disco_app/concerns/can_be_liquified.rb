module DiscoApp::Concerns::CanBeLiquified
  extend ActiveSupport::Concern

  SPLIT_ARRAY_SEPARATOR = '@!@'

  included do

    # Return this model as a hash for use with `to_liquid`. Returns `as_json` by default but is provided here as a hook
    # for potential overrides.
    def as_liquid
      as_json
    end

    # Render this model as a series of concatenated Liquid {%- assign -%} statements.
    def to_liquid
      as_liquid.map { |k, v| "{%- assign #{liquid_model_name}_#{k} = #{as_liquid_value(k, v)} -%}" }.join("\n")
    end

    # Method to allow override of the model name in Liquid. Useful for models
    # residing in namespaces that would otherwise have very long prefixes.
    def liquid_model_name
      model_name.param_key
    end

    private

      # Return given value as a string expression that will be evaluated in Liquid to result in the correct value type.
      def as_liquid_value(key, value)
        if value.is_a? Numeric or (!!value == value)
          return value.to_s
        end
        if value.nil?
          return 'nil'
        end
        if value.is_a? Array
          return "'#{value.map { |e| (e.is_a? String) ? CGI::escapeHTML(e) : e }.join(SPLIT_ARRAY_SEPARATOR)}' | split: '#{SPLIT_ARRAY_SEPARATOR}'"
        end
        if value.is_a? String and key.end_with? '_html'
          return "'#{value.to_s.gsub("'", "&#39;")}'"
        end
        "'#{CGI::escapeHTML(value.to_s)}'"
      end

  end

end
