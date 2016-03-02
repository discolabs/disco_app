class DiscoApp::SubscriptionsController < ApplicationController
  include DiscoApp::Concerns::AuthenticatedController

  def new
    @subscription = DiscoApp::Subscription.new
  end

  def create
    # Get the selected plan. If it's not available or couldn't be found,
    # redirect back to the plan selection page.
    if(plan = DiscoApp::Plan.available.find_by_id(subscription_params[:plan])).nil?
      redirect_to action: :new and return
    end

    # Subscribe the current shop to the selected plan.
    if DiscoApp::SubscriptionService.subscribe(@shop, plan)
      redirect_to main_app.root_path
    else
      redirect_to action: :new
    end
  end

  private

    def subscription_params
      params.require(:subscription).permit(:plan)
    end

end
