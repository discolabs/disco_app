namespace :dokku do

  desc 'Run set of tasks pre-deployment on dokku server'
  task predeploy: :environment do
    predeploy_service = DiscoApp::Dokku::PreDeploymentService.new
    predeploy_service.update_shopify_scopes
  end

  desc 'Run set of tasks post-deployment on dokku server'
  task postdeploy: :environment do
    postdeploy_service = DiscoApp::Dokku::PostDeploymentService.new
    postdeploy_service.run_migrations
  end

end
