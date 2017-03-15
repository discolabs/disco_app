class CreateDiscoAppSources < ActiveRecord::Migration
  def change
    create_table :disco_app_sources do |t|
      t.string :source, null: true
      t.string :name, null: true
      t.timestamps null: false
    end
  end
end
