class CreateDiscoAppSettings < ActiveRecord::Migration
  def change
    create_table :disco_app_app_settings do |t|

      t.timestamps null: false
    end
  end
end
