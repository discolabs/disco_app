class DiscoApp::AppInstalledJob < DiscoApp::ShopJob
  include DiscoApp::Concerns::AppInstalledJob

  def default_plan
   @default_plan ||= DiscoApp::Plan.first
  end

end
