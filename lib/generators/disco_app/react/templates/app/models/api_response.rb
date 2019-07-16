# frozen_string_literal: true

class ApiResponse

  EMPTY_SERIALIZER = 'Empty'
  ERROR_SERIALIZER = 'Error'
  SERIALIZER_SUFFIX = 'Serializer'
  SENSITIVE_REQUEST_PARAMS = ['timestamp', 'signature'].freeze

  def initialize(result, custom_serializer = nil)
    @result = result
    @custom_serializer = custom_serializer
  end

  def serialize(options = {})
    request = options.delete(:request)

    serializer.new(
      result, options.merge(collection_options(request))
    ).serializable_hash
  end

  def self.serialize(result, options = {})
    serializer = options.delete(:serializer)

    new(result, serializer).serialize(options)
  end

  private

    attr_accessor :result, :custom_serializer

    def array?
      result.is_a?(Array)
    end

    def collection?
      result.is_a?(ActiveRecord::Relation)
    end

    def error?
      [
        result.is_a?(ActiveModel::Errors),
        result.is_a?(ActiveResource::Errors),
        result.is_a?(StandardError),
        result.is_a?(String)
      ].any?
    end

    def empty?
      (array? || collection?) && result.empty?
    end

    def resource?
      !array && !collection? && !error?
    end

    def resource_type
      return custom_serializer.to_s.classify if custom_serializer
      return ERROR_SERIALIZER if error?
      return EMPTY_SERIALIZER if empty?
      return result.first.class.name if array?
      return result.class.to_s.deconstantize if collection?

      result.class.name
    end

    def serializer
      "#{resource_type}#{SERIALIZER_SUFFIX}".constantize
    end

    def collection_options(request = nil)
      options = {}

      return options if error?

      options[:is_collection] = array? || collection?

      if collection? && result.respond_to?(:total_count)
        options[:meta] = {
          page_size: result.limit_value,
          total_count: result.total_count,
          total_pages: result.total_pages
        }

        options[:links] = {
          prev: link(result.prev_page, request),
          next: link(result.next_page, request)
        }
      end

      options
    end

    def link(page, request)
      return page if page.blank? || request.blank?

      uri = URI.parse(request)
      params = Rack::Utils.parse_query(uri.query)
      params.delete_if{ |key| SENSITIVE_REQUEST_PARAMS.include?(key) }
      params['page[number]'] = page
      parsed_params = params.map{ |key, value| "#{key}=#{value}" }.join('&')

      "#{uri.scheme}:://#{uri.host}#{uri.path}?#{parsed_params}"
    end

end
