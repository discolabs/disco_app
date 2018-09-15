API_JSON = 'application/vnd.api+json'.freeze

Mime::Type.register(API_JSON, :jsonapi)

parsers = ActionDispatch::Request.parameter_parsers.merge(
  Mime[:jsonapi].symbol => ->(body) { JSON.parse(body) }
)
ActionDispatch::Request.parameter_parsers = parsers

ActionController::Renderers.add :jsonapi do |obj, _options|
  self.content_type ||= Mime[:jsonapi]
  self.response_body = obj.to_json
end
