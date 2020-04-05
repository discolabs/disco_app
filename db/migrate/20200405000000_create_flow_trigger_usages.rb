class CreateFlowTriggerUsages < ActiveRecord::Migration[5.2]

  def change
    create_table :disco_app_flow_trigger_usages do |t|
      t.integer :shop_id, limit: 8
      t.string :flow_trigger_definition_id
      t.boolean :has_enabled_flow, default: true
      t.datetime :timestamp, null: true
      t.timestamps null: false
    end

    add_foreign_key :disco_app_flow_trigger_usages, :disco_app_shops, column: :shop_id, on_delete: :cascade
    add_index :disco_app_flow_trigger_usages, [:shop_id, :flow_trigger_definition_id], unique: true, name: :index_disco_app_flow_actions_on_shop_id_and_trigger_id
  end

end
