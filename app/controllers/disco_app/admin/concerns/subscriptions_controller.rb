module DiscoApp::Admin::Concerns::SubscriptionsController
  extend ActiveSupport::Concern

  included do
    before_action :find_subscription
  end

  def edit
  end

  def update
    if @subscription.update_attributes(subscription_params)
      unless (@subscription.previous_changes.keys & ['amount', 'trial_period_days']).empty?

      end
      redirect_to edit_admin_subscription_path(@subscription)
    else
      render 'edit'
    end
  end

  private

    def find_subscription
      @subscription = DiscoApp::Subscription.find_by_id(params[:id])
    end

    def subscription_params
      params.require(:subscription).permit(:amount, :trial_period_days)
    end

end
