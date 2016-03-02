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
        price: subscription.amount.to_f / 100.0,
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

  # Fetch the specified charge for the given Shop using the Shopify API and check that it has been actioned (either
  # accepted or declined). Updates the shop object's charge status, then returns the charge if it was accepted or
  # nil otherwise.
  def self.get_accepted_charge(shop, charge_id)
    begin
      shopify_charge = shop.temp {
        self.charge_api_class(shop).find(charge_id)
      }

      # If the charge was successfully fetched, update the status for the shop accordingly.
      shop.update_charge_status(shopify_charge) if shopify_charge

      shopify_charge
    rescue
      nil
    end
  end

  # Attempt to activate the given Shopify charge for the given Shop using the Shopify API.
  # Returns true on successful activation, false otherwise.
  def self.activate(shop, shopify_charge)
    begin
      shop.temp {
        shopify_charge.activate
      }
      shop.charge_active!
      true
    rescue
      false
    end
  end

  # Merge the new_charge_attributes returned by the given shop model and merge them with some application-level
  # charge attributes.
  def self.new_charge_attributes(shop)
    shop.new_charge_attributes.merge(
      return_url: DiscoApp::Engine.routes.url_helpers.activate_charge_url,
      test: !Rails.configuration.x.shopify_charges_real,
    )
  end

  # Get the appropriate Shopify API class for the given shop (either ApplicationCharge or RecurringApplicationCharge).
  def self.charge_api_class(shop)
    if shop.new_charge_attributes[:type] == :one_time
      ShopifyAPI::ApplicationCharge
    else
      ShopifyAPI::RecurringApplicationCharge
    end
  end

end
