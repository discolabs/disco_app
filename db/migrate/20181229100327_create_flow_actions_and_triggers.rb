class CreateFlowActionsAndTriggers < ActiveRecord::Migration[5.2]

  def change
    create_table :disco_app_flow_actions do |t|
      t.integer :shop_id, limit: 8
      t.string :action_run_id
      t.jsonb :properties, default: {}
      t.integer :status, default: 0
      t.datetime :processed_at, null: true
      t.jsonb :processing_errors, default: []
      t.timestamps null: false
    end

    create_table :disco_app_flow_triggers do |t|
      t.integer :shop_id, limit: 8
      t.string :title
      t.string :resource_name
      t.string :resource_url
      t.jsonb :properties, default: {}
      t.integer :status, default: 0
      t.datetime :processed_at, null: true
      t.jsonb :processing_errors, default: []
      t.timestamps null: false
    end

    add_foreign_key :disco_app_flow_actions, :disco_app_shops, column: :shop_id
    add_foreign_key :disco_app_flow_triggers, :disco_app_shops, column: :shop_id
    add_index :disco_app_flow_actions, :action_run_id, unique: true
  end

end
