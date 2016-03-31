# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160331093148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disco_app_app_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disco_app_application_charges", force: :cascade do |t|
    t.integer  "shop_id",          limit: 8
    t.integer  "subscription_id",  limit: 8
    t.integer  "status",                     default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "shopify_id",       limit: 8
    t.string   "confirmation_url"
  end

  create_table "disco_app_plan_codes", force: :cascade do |t|
    t.integer  "disco_app_plan_id"
    t.string   "code"
    t.integer  "trial_period_days"
    t.integer  "amount"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "disco_app_plan_codes", ["disco_app_plan_id"], name: "index_disco_app_plan_codes_on_disco_app_plan_id", using: :btree

  create_table "disco_app_plans", force: :cascade do |t|
    t.integer  "status",            default: 0
    t.string   "name"
    t.integer  "plan_type",         default: 0
    t.integer  "trial_period_days"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "amount",            default: 0
    t.string   "currency",          default: "USD"
    t.integer  "interval",          default: 0
    t.integer  "interval_count",    default: 1
  end

  create_table "disco_app_recurring_application_charges", force: :cascade do |t|
    t.integer  "shop_id",          limit: 8
    t.integer  "subscription_id",  limit: 8
    t.integer  "status",                     default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "shopify_id",       limit: 8
    t.string   "confirmation_url"
  end

  create_table "disco_app_sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "shop_id"
  end

  add_index "disco_app_sessions", ["session_id"], name: "index_disco_app_sessions_on_session_id", unique: true, using: :btree
  add_index "disco_app_sessions", ["updated_at"], name: "index_disco_app_sessions_on_updated_at", using: :btree

  create_table "disco_app_shops", force: :cascade do |t|
    t.string   "shopify_domain",                         null: false
    t.string   "shopify_token",                          null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "status",                     default: 0
    t.string   "email"
    t.string   "country_name"
    t.string   "currency"
    t.string   "money_format"
    t.string   "money_with_currency_format"
    t.string   "domain"
    t.string   "plan_name"
    t.string   "plan_display_name"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "customer_email"
    t.boolean  "password_enabled"
    t.string   "phone"
    t.string   "primary_locale"
    t.string   "ships_to_countries"
    t.string   "timezone"
    t.string   "iana_timezone"
    t.boolean  "has_storefront"
  end

  add_index "disco_app_shops", ["shopify_domain"], name: "index_disco_app_shops_on_shopify_domain", unique: true, using: :btree

  create_table "disco_app_subscriptions", force: :cascade do |t|
    t.integer  "shop_id"
    t.integer  "plan_id"
    t.integer  "status"
    t.integer  "subscription_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "trial_start_at"
    t.datetime "trial_end_at"
    t.datetime "cancelled_at"
  end

  add_index "disco_app_subscriptions", ["plan_id"], name: "index_disco_app_subscriptions_on_plan_id", using: :btree
  add_index "disco_app_subscriptions", ["shop_id"], name: "index_disco_app_subscriptions_on_shop_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "shop_id",    limit: 8
    t.jsonb    "data"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_foreign_key "disco_app_application_charges", "disco_app_shops", column: "shop_id"
  add_foreign_key "disco_app_application_charges", "disco_app_subscriptions", column: "subscription_id"
  add_foreign_key "disco_app_plan_codes", "disco_app_plans"
  add_foreign_key "disco_app_recurring_application_charges", "disco_app_shops", column: "shop_id"
  add_foreign_key "disco_app_recurring_application_charges", "disco_app_subscriptions", column: "subscription_id"
  add_foreign_key "disco_app_sessions", "disco_app_shops", column: "shop_id", on_delete: :cascade
  add_foreign_key "products", "disco_app_shops", column: "shop_id"
end
