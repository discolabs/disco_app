# This migration comes from disco_app (originally 20150814214025)
class AddMoreMetaToShops < ActiveRecord::Migration
  def change
    add_column :shops, :plan_display_name, :string
    add_column :shops, :latitude, :decimal
    add_column :shops, :longitude, :decimal
    add_column :shops, :customer_email, :string
    add_column :shops, :password_enabled, :boolean
    add_column :shops, :phone, :string
    add_column :shops, :primary_locale, :string
    add_column :shops, :ships_to_countries, :string
    add_column :shops, :timezone, :string
    add_column :shops, :iana_timezone, :string
    add_column :shops, :has_storefront, :boolean
  end
end
