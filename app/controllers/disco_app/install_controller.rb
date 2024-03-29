class DiscoApp::InstallController < ApplicationController

  include DiscoApp::Concerns::AuthenticatedController

  skip_before_action :check_current_subscription
  skip_before_action :check_active_charge

  # Start the installation process for the current shop, then redirect to the installing screen.
  def install
    DiscoApp::AppInstalledJob.perform_later(@shop, cookies[DiscoApp::CODE_COOKIE_KEY], cookies[DiscoApp::SOURCE_COOKIE_KEY])
    redirect_to action: :installing
  end

  # Display an "installing" page.
  def installing
    redirect_to main_app.root_path if @shop.installed?
  end

  # Display an "uninstalling" page. Should be almost never used.
  def uninstalling
    redirect_to main_app.root_path if @shop.uninstalled?
  end

end
