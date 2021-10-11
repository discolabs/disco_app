class DiscoApp::ChargesService

  # Create the appropriate type of Shopify charge for the given subscription
  # (either one-time or recurring) and return.
  def self.create(shop, subscription)
    # Create the charge object locally first.
    charge = subscription.charge_class.create!(
      shop: shop,
      subscription: subscription
    )

    # Create the charge object on Shopify.
    shopify_charge = shop.with_api_context do
      subscription.shopify_charge_class.create(
        name: subscription.plan.name,
        price: format('%.2f', (subscription.amount.to_f / 100.0)),
        trial_days: subscription.plan.has_trial? ? subscription.trial_period_days : nil,
        return_url: charge.activate_url,
        test: !DiscoApp.configuration.real_charges?
      )
    end

    # If we couldn't create the charge on Shopify, return nil.
    return nil if shopify_charge.nil?

    # Update the local record of the charge from Shopify's created charge, then
    # return it.
    charge.update(
      shopify_id: shopify_charge.id,
      confirmation_url: shopify_charge.confirmation_url
    )
    charge
  end

  # Synchronises the status of a given charge from the Shopify API and returns
  # true if it's active (and false otherwise).
  #
  # Previously, the activation of a charge also required updating Shopify via the
  # API, but that requirement has been removed.
  #
  # See https://shopify.dev/changelog/auto-activation-of-charges-and-subscriptions
  def self.activate(shop, charge)
    # Start by fetching the Shopify charge to check that it was accepted.
    shopify_charge = shop.with_api_context do
      charge.subscription.shopify_charge_class.find(charge.shopify_id)
    end

    # Update the status of the local charge based on the Shopify charge.
    charge.send("#{shopify_charge.status}!") if charge.respond_to? "#{shopify_charge.status}!"

    # If the charge isn't active, fail and return.
    return false unless charge.active?

    # If the charge was recurring, make sure that all other local recurring
    # charges are marked inactive.
    cancel_recurring_charges(shop, charge) if charge.recurring?

    true
  rescue StandardError
    false
  end

  # Cancel all recurring charges for the given shop. If the optional charge
  # parameter is given, it will be excluded from the cancellation.
  def self.cancel_recurring_charges(shop, charge = nil)
    charges = DiscoApp::RecurringApplicationCharge.where(shop: shop)
    charges = charges.where.not(id: charge) if charge.present?
    charges.update_all(status: DiscoApp::RecurringApplicationCharge.statuses[:cancelled]) # rubocop:disable Rails/SkipsModelValidations
  end

end
