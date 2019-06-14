class DiscoApp::SubscriptionService

  # Subscribe the given shop to the given plan, optionally using the given plan
  # code and optionally tracking the subscription source.
  def self.subscribe(shop, plan, plan_code = nil, source_name = nil)
    new(shop, plan, plan_code, source_name).subscribe
  end

  attr_reader :shop, :plan, :plan_code, :source_name

  def initialize(shop, plan, plan_code = nil, source_name = nil)
    @shop = shop
    @plan = plan
    @plan_code = plan_code
    @source_name = source_name
  end

  def subscribe
    cancel_existing_subscriptions

    # Create the new subscription.
    new_subscription = create_new_subscription

    # Enqueue the subscription changed background job.
    DiscoApp::SubscriptionChangedJob.perform_later(shop, new_subscription)

    # Return the new subscription.
    new_subscription
  end

  private

    # If a plan code was provided, fetch it for the given plan.
    def plan_code_instance
      return unless plan_code.present?

      @plan_code_instance ||= DiscoApp::PlanCode.available.find_by(plan: plan, code: plan_code)
    end

    # If a source name has been provided, fetch or create it
    def source_instance
      return unless source_name.present?

      @source_instance ||= DiscoApp::Source.find_or_create_by(source: source_name)
    end

    # Cancel any existing current subscriptions.
    def cancel_existing_subscriptions
      shop.subscriptions.current.update_all(
        status: DiscoApp::Subscription.statuses[:cancelled],
        cancelled_at: Time.now
      )
    end

    # Get the amount that should be charged for the subscription.
    def subscription_amount
      plan_code_instance.present? ? plan_code_instance.amount : plan.amount
    end

    # Get the date the subscription trial should end.
    def subscription_trial_period_days
      plan_code_instance.present? ? plan_code_instance.trial_period_days : plan.trial_period_days
    end

    def create_new_subscription
      DiscoApp::Subscription.create!(
        shop: shop,
        plan: plan,
        plan_code: plan_code_instance,
        status: DiscoApp::Subscription.statuses[plan.has_trial? ? :trial : :active],
        subscription_type: plan.plan_type,
        amount: subscription_amount,
        trial_period_days: plan.has_trial? ? subscription_trial_period_days : nil,
        trial_start_at: plan.has_trial? ? Time.now : nil,
        trial_end_at: plan.has_trial? ? subscription_trial_period_days.days.from_now : nil,
        source: source_instance
      )
    end
end
