class DiscoApp::ChargesController < ApplicationController
  include DiscoApp::Concerns::AuthenticatedController

  before_action :find_subscription

  # Display a "pre-charge" page, giving the opportunity to explain why a charge
  # needs to be made.
  def new
  end

  # Attempt to create a new charge for the logged in shop and selected
  # subscription. If successful, redirect to the (external) charge confirmation
  # URL. If it fails, redirect back to the new charge page.
  def create
    if(charge = DiscoApp::ChargesService.create(@shop, @subscription)).nil?
      redirect_to action: :new
    else
      redirect_to charge.confirmation_url
    end
  end

  # Attempt to activate a charge after a user has accepted or declined it. Redirect to the main application's root URL
  # immediately afterwards - if the charge wasn't accepted, the flow will start again.
  def activate
    # if (shopify_charge = DiscoApp::ChargesService.get_accepted_charge(@shop, params[:charge_id])).nil?
    #   redirect_to action: :new and return
    # end
    # DiscoApp::ChargesService.activate(@shop, shopify_charge)
    # redirect_to main_app.root_url
  end

  private

    def find_subscription
      @subscription = @shop.subscriptions.find_by_id!(params[:subscription_id])
      unless @subscription.requires_accepted_charge? and not @subscription.accepted_charge?
        redirect_to main_app.root_url
      end
    end

end
