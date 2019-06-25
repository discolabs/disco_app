class DiscoApp::ChargesController < ApplicationController

  include DiscoApp::Concerns::AuthenticatedController

  skip_before_action :check_active_charge
  before_action :find_subscription

  # Display a "pre-charge" page, giving the opportunity to explain why a charge
  # needs to be made.
  def new
  end

  # Attempt to create a new charge for the logged in shop and selected
  # subscription. If successful, redirect to the (external) charge confirmation
  # URL. If it fails, redirect back to the new charge page.
  def create
    if (charge = DiscoApp::ChargesService.create(@shop, @subscription)).nil?
      redirect_to action: :new
    else
      redirect_to charge.confirmation_url
    end
  end

  # Attempt to activate a charge after a user has accepted or declined it.
  # Redirect to the main application's root URL immediately afterwards - if the
  # charge wasn't accepted, the flow will start again.
  def activate
    # First attempt to find a matching charge.
    if (charge = @subscription.charges.find_by(id: params[:id], shopify_id: params[:charge_id])).nil?
      redirect_to(action: :new) && return
    end
    if DiscoApp::ChargesService.activate(@shop, charge)
      redirect_to main_app.root_url
    else
      redirect_to action: :new
    end
  end

  private

    def find_subscription
      @subscription = @shop.subscriptions.find_by_id!(params[:subscription_id])
      redirect_to main_app.root_url unless @subscription.requires_active_charge? && !@subscription.active_charge?
    end

end
