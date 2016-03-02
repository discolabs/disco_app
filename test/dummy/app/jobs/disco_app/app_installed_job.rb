class DiscoApp::AppInstalledJob < DiscoApp::ShopJob
  include DiscoApp::Concerns::AppInstalledJob

  DEVELOPMENT_PLAN_ID = 1

  # Implement the default_plan method to define an initial plan for shops based
  # on their status.
  def default_plan
    @default_plan ||= begin
      if @shop.plan_name === 'affiliate'
        DiscoApp::Plan.find(DEVELOPMENT_PLAN_ID)
      end
    end
  end

end
