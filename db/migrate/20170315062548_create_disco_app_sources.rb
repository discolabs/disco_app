class CreateDiscoAppSources < ActiveRecord::Migration[5.1]
  def change
    create_table :disco_app_sources do |t|
      t.string :source, null: true
      t.string :name, null: true
      t.timestamps null: false
    end
    add_index :disco_app_sources, :source
  end
end
