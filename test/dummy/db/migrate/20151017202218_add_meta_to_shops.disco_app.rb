# This migration comes from disco_app (originally 20150525171422)
class AddMetaToShops < ActiveRecord::Migration
  def change
    add_column :shops, :email, :string
    add_column :shops, :country_name, :string
    add_column :shops, :currency, :string
    add_column :shops, :money_format, :string
    add_column :shops, :money_with_currency_format, :string
    add_column :shops, :domain, :string
    add_column :shops, :plan_name, :string
  end
end
