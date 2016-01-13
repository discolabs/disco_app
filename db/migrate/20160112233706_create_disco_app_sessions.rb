class CreateDiscoAppSessions < ActiveRecord::Migration
  def change
    create_table :disco_app_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :disco_app_sessions, :session_id, :unique => true
    add_index :disco_app_sessions, :updated_at
  end
end
