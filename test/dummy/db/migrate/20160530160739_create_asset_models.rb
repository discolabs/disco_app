class CreateAssetModels < ActiveRecord::Migration
  def change
    create_table :js_configurations do |t|
      t.integer :shop_id, limit: 8
      t.string :label, default: 'Default'
      t.string :locale, default: 'en'
    end

    create_table :widget_configurations do |t|
      t.integer :shop_id, limit: 8
      t.string :label, default: 'Default'
      t.string :locale, default: 'en'
      t.string :background_color, default: '#FFFFFF'
    end

    add_foreign_key :js_configurations, :disco_app_shops, column: :shop_id
    add_foreign_key :widget_configurations, :disco_app_shops, column: :shop_id
  end
end
