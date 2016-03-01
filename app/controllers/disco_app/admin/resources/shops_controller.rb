class DiscoApp::Admin::Resources::ShopsController < JSONAPI::ResourceController
  include DiscoApp::Admin::Concerns::AuthenticatedController
end
