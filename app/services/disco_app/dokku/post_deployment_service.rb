module DiscoApp
  module Dokku
    class PostDeploymentService < BaseService

      def run_migrations
        Rake::Task['db:migrate'].invoke('RAILS_ENV=production')
        dokkuish_message('Database migrations successfully ran')
      end
    end
  end
end
