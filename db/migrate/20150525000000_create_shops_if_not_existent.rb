class CreateShopsIfNotExistent < ActiveRecord::Migration

  def change
    unless table_exists? :shops or table_exists? :disco_app_shops
      create_table :shops  do |t|
        t.string :shopify_domain, null: false
        t.string :shopify_token, null: false
        t.timestamps null: false
      end

      add_index :shops, :shopify_domain, unique: true
    end
  end

end
