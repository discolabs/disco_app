class DiscoApp::ChargesService

  # Create the appropriate type of Shopify charge for the given subscription
  # (either one-time or recurring) and return.
  def self.create(shop, subscription)
    # Create the charge object locally first.
    charge = subscription.charge_class.create!(
      shop: shop,
      subscription: subscription,
    )

    # Create the charge object on Shopify.
    shopify_charge = shop.temp {
      subscription.shopify_charge_class.create(
        name: subscription.plan.name,
        price: '%.2f' % (subscription.amount.to_f / 100.0),
        trial_days: subscription.plan.has_trial? ? subscription.plan.trial_period_days : nil,
        return_url: charge.activate_url,
      )
    }

    # If we couldn't create the charge on Shopify, return nil.
    if shopify_charge.nil?
      return nil
    end

    # Update the local record of the charge from Shopify's created charge, then
    # return it.
    charge.update(
      shopify_id: shopify_charge.id,
      confirmation_url: shopify_charge.confirmation_url
    )
    charge
  end

  # Attempt to activate the given Shopify charge for the given Shop using the
  # Shopify API. Returns true on successful activation, false otherwise.
  def self.activate(shop, charge)
    begin
      # Start by fetching the Shopify charge to check that it was accepted.
      shopify_charge = shop.temp {
        charge.subscription.shopify_charge_class.find(charge.shopify_id)
      }

      # Update the status of the local charge based on the Shopify charge.
      charge.send("#{shopify_charge.status}!") if charge.respond_to? "#{shopify_charge.status}!"

      # If the charge wasn't accepted, fail and return.
      return false unless charge.accepted?

      # If the charge was indeed accepted, activate it and return true.
      charge.shop.temp {
        shopify_charge.activate
      }

      charge.active!

      true
    rescue
      false
    end
  end

end
