require 'shopify_app'
require 'bootstrap-sass'
require 'jquery-rails'
require 'turbolinks'

module DiscoApp
  class Engine < ::Rails::Engine
    isolate_namespace DiscoApp
    engine_name 'disco_app'
  end
end
