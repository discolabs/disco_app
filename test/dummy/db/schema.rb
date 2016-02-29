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

ActiveRecord::Schema.define(version: 20160223111044) do

  create_table "disco_app_app_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disco_app_plans", force: :cascade do |t|
    t.integer  "status"
    t.string   "name"
    t.integer  "charge_type"
    t.decimal  "default_price"
    t.integer  "default_trial_days"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "disco_app_sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "disco_app_sessions", ["session_id"], name: "index_disco_app_sessions_on_session_id", unique: true
  add_index "disco_app_sessions", ["updated_at"], name: "index_disco_app_sessions_on_updated_at"

  create_table "disco_app_shops", force: :cascade do |t|
    t.string   "shopify_domain",                         null: false
    t.string   "shopify_token",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                     default: 0
    t.string   "email"
    t.string   "country_name"
    t.string   "currency"
    t.string   "money_format"
    t.string   "money_with_currency_format"
    t.string   "domain"
    t.string   "plan_name"
    t.integer  "charge_status",              default: 6
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

  add_index "disco_app_shops", ["shopify_domain"], name: "index_disco_app_shops_on_shopify_domain", unique: true

  create_table "disco_app_subscriptions", force: :cascade do |t|
    t.integer  "shop_id"
    t.integer  "plan_id"
    t.integer  "status"
    t.string   "name"
    t.integer  "charge_type"
    t.decimal  "price"
    t.integer  "trial_days"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "disco_app_subscriptions", ["plan_id"], name: "index_disco_app_subscriptions_on_plan_id"
  add_index "disco_app_subscriptions", ["shop_id"], name: "index_disco_app_subscriptions_on_shop_id"

end
