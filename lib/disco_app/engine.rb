require 'shopify_app'

module DiscoApp
  class Engine < ::Rails::Engine

    isolate_namespace DiscoApp
    engine_name 'disco_app'

    # Ensure our engine's migrations are included in any parent application's
    # migration listing.
    # http://blog.pivotal.io/labs/labs/leave-your-migrations-in-your-rails-engines.
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

  end
end
