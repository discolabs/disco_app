module DiscoApp
  class ChargesService

    # Create a new charge for the given Shop using the Shopify API.
    #
    # The attributes of the charge are fetched using the shop's `new_charge_attributes` method, which can be overriden
    # to provide custom charge types for individual shops.
    #
    # Returns the new Shopify charge model on success, nil otherwise.
    def self.create_new_charge(shop)
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

    # Attempt to activate the given charge for the given shop.
    def self.activate_charge(shop, charge_id)
      return nil unless charge_id

      begin
        # First, check the charge exists and belongs to this shop.
        shopify_charge = shop.temp {
          self.charge_api_class(shop).find(charge_id)
        }

        # Bail if the charge doesn't exist.
        unless shopify_charge
          return nil
        end

        # Update the state of the charge.
        if shopify_charge.status.to_sym == :accepted
          shop.charge_accepted!
        elsif shopify_charge.status.to_sym == :declined
          shop.charge_declined!
        end

        # Attempt to activate the charge if it was accepted.
        if shop.charge_accepted?
          shop.temp {
            shopify_charge.activate
          }
          shop.charge_activated!
          shopify_charge
        end
      rescue
        nil
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
