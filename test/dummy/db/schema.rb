# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_29_100327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carts", id: :serial, force: :cascade do |t|
    t.bigint "shop_id"
    t.string "token"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_carts_on_token", unique: true
  end

  create_table "disco_app_app_settings", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disco_app_application_charges", id: :serial, force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "subscription_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shopify_id"
    t.string "confirmation_url"
  end

  create_table "disco_app_flow_actions", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "action_id"
    t.string "action_run_id"
    t.jsonb "properties", default: {}
    t.integer "status", default: 0
    t.datetime "processed_at"
    t.jsonb "processing_errors", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_run_id"], name: "index_disco_app_flow_actions_on_action_run_id", unique: true
  end

  create_table "disco_app_flow_triggers", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "title"
    t.string "resource_name"
    t.string "resource_url"
    t.jsonb "properties", default: {}
    t.integer "status", default: 0
    t.datetime "processed_at"
    t.jsonb "processing_errors", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disco_app_plan_codes", id: :serial, force: :cascade do |t|
    t.bigint "plan_id"
    t.string "code"
    t.integer "trial_period_days"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
  end

  create_table "disco_app_plans", id: :serial, force: :cascade do |t|
    t.integer "status", default: 0
    t.string "name"
    t.integer "plan_type", default: 0
    t.integer "trial_period_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount", default: 0
    t.string "currency", default: "USD"
    t.integer "interval", default: 0
    t.integer "interval_count", default: 1
  end

  create_table "disco_app_recurring_application_charges", id: :serial, force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "subscription_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shopify_id"
    t.string "confirmation_url"
  end

  create_table "disco_app_sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id"
    t.index ["session_id"], name: "index_disco_app_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_disco_app_sessions_on_updated_at"
  end

  create_table "disco_app_shops", id: :serial, force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "domain"
    t.string "plan_name"
    t.string "name"
    t.jsonb "data", default: {}
    t.index ["shopify_domain"], name: "index_disco_app_shops_on_shopify_domain", unique: true
  end

  create_table "disco_app_sources", id: :serial, force: :cascade do |t|
    t.string "source"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source"], name: "index_disco_app_sources_on_source"
  end

  create_table "disco_app_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "shop_id"
    t.integer "plan_id"
    t.integer "status"
    t.integer "subscription_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "trial_start_at"
    t.datetime "trial_end_at"
    t.datetime "cancelled_at"
    t.integer "amount", default: 0
    t.bigint "plan_code_id"
    t.integer "trial_period_days"
    t.bigint "source_id"
    t.index ["plan_id"], name: "index_disco_app_subscriptions_on_plan_id"
    t.index ["shop_id"], name: "index_disco_app_subscriptions_on_shop_id"
  end

  create_table "disco_app_users", id: :serial, force: :cascade do |t|
    t.bigint "shop_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "shop_id"], name: "index_disco_app_users_on_id_and_shop_id", unique: true
  end

  create_table "js_configurations", id: :serial, force: :cascade do |t|
    t.bigint "shop_id"
    t.string "label", default: "Default"
    t.string "locale", default: "en"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.bigint "shop_id"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "widget_configurations", id: :serial, force: :cascade do |t|
    t.bigint "shop_id"
    t.string "label", default: "Default"
    t.string "locale", default: "en"
    t.string "background_color", default: "#FFFFFF"
  end

  add_foreign_key "carts", "disco_app_shops", column: "shop_id"
  add_foreign_key "disco_app_application_charges", "disco_app_shops", column: "shop_id"
  add_foreign_key "disco_app_application_charges", "disco_app_subscriptions", column: "subscription_id"
  add_foreign_key "disco_app_flow_actions", "disco_app_shops", column: "shop_id"
  add_foreign_key "disco_app_flow_triggers", "disco_app_shops", column: "shop_id"
  add_foreign_key "disco_app_plan_codes", "disco_app_plans", column: "plan_id"
  add_foreign_key "disco_app_recurring_application_charges", "disco_app_shops", column: "shop_id"
  add_foreign_key "disco_app_recurring_application_charges", "disco_app_subscriptions", column: "subscription_id"
  add_foreign_key "disco_app_sessions", "disco_app_shops", column: "shop_id", on_delete: :cascade
  add_foreign_key "disco_app_subscriptions", "disco_app_plan_codes", column: "plan_code_id"
  add_foreign_key "disco_app_subscriptions", "disco_app_sources", column: "source_id"
  add_foreign_key "js_configurations", "disco_app_shops", column: "shop_id"
  add_foreign_key "products", "disco_app_shops", column: "shop_id"
  add_foreign_key "widget_configurations", "disco_app_shops", column: "shop_id"
end
