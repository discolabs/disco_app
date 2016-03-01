module DiscoApp
  class ChargesController < ApplicationController
    include DiscoApp::Concerns::AuthenticatedController

    skip_before_action :verify_status, only: [:create, :activate]

    # Display a "pre-charge" page, giving the opportunity to explain why a charge needs to be made.
    def new
    end

    # Create a new charge for the currently logged in shop, then redirect to the charge's confirmation URL.
    def create
      if (shopify_charge = DiscoApp::ChargesService.create(@shop)).nil?
        redirect_to action: :new and return
      end
      redirect_to shopify_charge.confirmation_url
    end

    # Attempt to activate a charge after a user has accepted or declined it. Redirect to the main application's root URL
    # immediately afterwards - if the charge wasn't accepted, the flow will start again.
    def activate
      if (shopify_charge = DiscoApp::ChargesService.get_accepted_charge(@shop, params[:charge_id])).nil?
        redirect_to action: :new and return
      end
      DiscoApp::ChargesService.activate(@shop, shopify_charge)
      redirect_to main_app.root_url
    end

  end
end
