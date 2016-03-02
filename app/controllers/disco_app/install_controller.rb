class DiscoApp::InstallController < ApplicationController
  include DiscoApp::Concerns::AuthenticatedController

  # Start the installation process for the current shop, then redirect to the installing screen.
  def install
    AppInstalledJob.perform_later(@shop.shopify_domain)
    redirect_to action: :installing
  end

  # Display an "installing" page.
  def installing
    if @shop.installed?
      redirect_to main_app.root_path
    end
  end

  # Display an "uninstalling" page. Should be almost never used.
  def uninstalling
    if @shop.uninstalled?
      redirect_to main_app.root_path
    end
  end

end
