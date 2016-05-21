class MoveShopToSynchronises < ActiveRecord::Migration

  class DiscoApp::Shop < ActiveRecord::Base
  end

  ATTRIBUTES_TO_MIGRATE = [
    :email, :country_name, :currency, :money_format,
    :money_with_currency_format, :plan_display_name,
    :latitude, :longitude, :customer_email, :password_enabled, :phone,
    :primary_locale, :ships_to_countries, :timezone, :iana_timezone,
    :has_storefront
  ]

  def up
    add_column :disco_app_shops, :data, :jsonb, default: {}

    DiscoApp::Shop.find_each do |shop|
      data = shop.data
      ATTRIBUTES_TO_MIGRATE.each do |attribute|
        data[attribute.to_s] = shop.send(attribute)
      end
      shop.update(data: data)
    end

    ATTRIBUTES_TO_MIGRATE.each do |attribute|
      remove_column :disco_app_shops, attribute
    end
  end

  def down
    ATTRIBUTES_TO_MIGRATE.each do |attribute|
      add_column :disco_app_shops, attribute, attribute_column_type(attribute)
    end

    DiscoApp::Shop.find_each do |shop|
      shop.update(Hash[ATTRIBUTES_TO_MIGRATE.map do |attribute|
        [attribute, shop.data[attribute.to_s]]
      end])
    end

    remove_column :disco_app_shops, :data
  end

  private

    def attribute_column_type(attribute)
      case attribute
        when :password_enabled
          :boolean
        when :has_storefront
          :boolean
        when :latitude
          :decimal
        when :longitude
          :decimal
        else
          :string
      end
    end

end
