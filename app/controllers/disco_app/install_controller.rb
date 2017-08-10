class DiscoApp::InstallController < ApplicationController
  include DiscoApp::Concerns::AuthenticatedController

  skip_before_action :check_current_subscription
  skip_before_action :check_active_charge

  before_action :check_whitelisted

  # Start the installation process for the current shop, then redirect to the installing screen.
  def install
    DiscoApp::AppInstalledJob.perform_later(@shop, cookies[DiscoApp::CODE_COOKIE_KEY], cookies[DiscoApp::SOURCE_COOKIE_KEY])
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

  private

    def check_whitelisted
      if ENV['WHITELISTED_DOMAINS'].present? and not ENV['WHITELISTED_DOMAINS'].include?(@shop.shopify_domain)
        redirect_to_login
      end
    end

end
