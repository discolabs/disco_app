class DiscoApp::SubscriptionService

  # Subscribe the given shop to the given plan, optionally using the given plan
  # code.
  def self.subscribe(shop, plan, plan_code = nil)
    # Cancel any existing current subscriptions.
    shop.subscriptions.current.update_all(
      status: DiscoApp::Subscription.statuses[:cancelled],
      cancelled_at: Time.now
    )

    # Get the amount that should be charged for the subscription.
    subscription_amount = plan_code.present? ? plan_code.amount : plan.amount

    # Get the date the subscription trial should end.
    subscription_trial_end_at = plan.has_trial? ? (plan_code.present? ? plan_code.trial_period_days: plan.trial_period_days).days.from_now : nil

    # Create the new subscription.
    new_subscription = DiscoApp::Subscription.create!(
      shop: shop,
      plan: plan,
      plan_code: plan_code,
      status: DiscoApp::Subscription.statuses[plan.has_trial? ? :trial : :active],
      subscription_type: plan.plan_type,
      amount: subscription_amount,
      trial_start_at: plan.has_trial? ? Time.now : nil,
      trial_end_at: plan.has_trial? ? subscription_trial_end_at : nil
    )

    # Enqueue the subscription changed background job.
    DiscoApp::SubscriptionChangedJob.perform_later(shop.shopify_domain, new_subscription)

    # Return the new subscription.
    new_subscription
  end

end
