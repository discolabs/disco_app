class DiscoApp::SubscriptionsController < ApplicationController
  include DiscoApp::Concerns::AuthenticatedController

  skip_before_action :check_current_subscription

  def new
    @subscription = DiscoApp::Subscription.new
  end

  def create
    # Get the selected plan. If it's not available or couldn't be found,
    # redirect back to the plan selection page.
    if(plan = DiscoApp::Plan.available.find_by_id(subscription_params[:plan])).nil?
      redirect_to action: :new and return
    end

    # If a plan code was provided, check that it's (a) valid and available and
    # (b) valid for the selected plan.
    plan_code = nil
    if subscription_params[:plan_code].present?
      if(plan_code = DiscoApp::PlanCode.available.find_by(plan: plan, code: subscription_params[:plan_code])).nil?
        redirect_to action: :new and return
      end
    end

    # Subscribe the current shop to the selected plan.
    if(subscription = DiscoApp::SubscriptionService.subscribe(@shop, plan, plan_code)).nil?
      redirect_to action: :new
    else
      redirect_to main_app.root_path
    end
  end

  private

    def subscription_params
      params.require(:subscription).permit(:plan, :plan_code)
    end

end
