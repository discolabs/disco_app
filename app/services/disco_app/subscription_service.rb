class DiscoApp::SubscriptionService

  # Subscribe the given shop to the given plan.
  def self.subscribe(shop, plan)
    # Mark all existing active subscriptions as replaced.
    shop.subscriptions.active.update_all(status: DiscoApp::Subscription.statuses[:replaced])

    # Add the new subscription.
    DiscoApp::Subscription.create!(
      shop: shop,
      plan: plan,
      status: DiscoApp::Subscription.statuses[:active],
      name: plan.name,
      charge_type: plan.charge_type,
      price: plan.default_price,
      trial_days: plan.default_trial_days
    )
  end

  # Cancel any active subscription for the given shop.
  def self.cancel(shop)
    shop.subscriptions.active.update_all(status: DiscoApp::Subscription.statuses[:cancelled])
  end

end
