module DiscoApp
  class ChargesService

    # Create a new charge for the given Shop using the Shopify API.
    #
    # The attributes of the charge are fetched using the shop's `new_charge_attributes` method, which can be overriden
    # to provide custom charge types for individual shops.
    #
    # Returns the new Shopify charge model on success, nil otherwise.
    def self.create(shop)
      shopify_charge = shop.temp {
        self.charge_api_class(shop).create(self.new_charge_attributes(shop))
      }

      # If the charge was successfully created, update the charge status on the shop.
      if shopify_charge
        shop.charge_pending!
      end

      # Return the charge.
      shopify_charge
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
        if shopify_charge
          # Update the state of the charge.
          if shopify_charge.status.to_sym == :accepted
            shop.charge_accepted!
          elsif shopify_charge.status.to_sym == :declined
            shop.charge_declined!
          end
        end

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
        shop.charge_activated!
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
end
