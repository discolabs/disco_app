class AddShopifyAttributesToCharges < ActiveRecord::Migration
  def change
    add_column :disco_app_application_charges, :shopify_id, :integer, limit: 8, null: true
    add_column :disco_app_recurring_application_charges, :shopify_id, :integer, limit: 8, null: true
    add_column :disco_app_application_charges, :confirmation_url, :string, null: true
    add_column :disco_app_recurring_application_charges, :confirmation_url, :string, null: true
  end
end
