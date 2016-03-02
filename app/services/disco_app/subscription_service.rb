class DiscoApp::SubscriptionService

  # Subscribe the given shop to the given plan.
  def self.subscribe(shop, plan)
    # Cancel any existing current subscriptions.
    shop.subscriptions.current.update_all(
      status: DiscoApp::Subscription.statuses[:cancelled],
      cancelled_at: Time.now
    )

    # Create the new subscription.
    new_subscription = DiscoApp::Subscription.create!(
      shop: shop,
      plan: plan,
      status: DiscoApp::Subscription.statuses[plan.has_trial? ? :trial : :active],
      subscription_type: plan.plan_type,
      trial_start_at: plan.has_trial? ? Time.now : nil,
      trial_end_at: plan.has_trial? ? plan.trial_period_days.days.from_now : nil
    )

    # Enqueue the subscription changed background job.
    DiscoApp::SubscriptionChangedJob.perform_later(shop.shopify_domain, new_subscription)

    # Return the new subscription.
    new_subscription
  end

end
