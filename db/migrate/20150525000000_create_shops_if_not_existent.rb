##
# While this migration file is called "create shops if not existent", it's actually a reset of all `disco_app`
# migrations up until 23 January 2017. It's kept its name like this to ensure compatibility across upgraded apps.
class CreateShopsIfNotExistent < ActiveRecord::Migration[5.1]

  def change
    return if table_exists? :disco_app_shops

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
      t.integer  "plan_id",           limit: 8
      t.string   "code"
      t.integer  "trial_period_days"
      t.integer  "amount"
      t.datetime "created_at",                              null: false
      t.datetime "updated_at",                              null: false
      t.integer  "status",                      default: 0
    end

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
      t.string   "shopify_domain",              null: false
      t.string   "shopify_token",               null: false
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.integer  "status",         default: 0
      t.string   "domain"
      t.string   "plan_name"
      t.string   "name"
      t.jsonb    "data",           default: {}
    end

    add_index "disco_app_shops", ["shopify_domain"], name: "index_disco_app_shops_on_shopify_domain", unique: true, using: :btree

    create_table "disco_app_subscriptions", force: :cascade do |t|
      t.integer  "shop_id"
      t.integer  "plan_id"
      t.integer  "status"
      t.integer  "subscription_type"
      t.datetime "created_at",                              null: false
      t.datetime "updated_at",                              null: false
      t.datetime "trial_start_at"
      t.datetime "trial_end_at"
      t.datetime "cancelled_at"
      t.integer  "amount",                      default: 0
      t.integer  "plan_code_id",      limit: 8
      t.string   "source"
      t.integer  "trial_period_days"
    end

    add_index "disco_app_subscriptions", ["plan_id"], name: "index_disco_app_subscriptions_on_plan_id", using: :btree
    add_index "disco_app_subscriptions", ["shop_id"], name: "index_disco_app_subscriptions_on_shop_id", using: :btree

    add_foreign_key "disco_app_application_charges", "disco_app_shops", column: "shop_id"
    add_foreign_key "disco_app_application_charges", "disco_app_subscriptions", column: "subscription_id"
    add_foreign_key "disco_app_plan_codes", "disco_app_plans", column: "plan_id"
    add_foreign_key "disco_app_recurring_application_charges", "disco_app_shops", column: "shop_id"
    add_foreign_key "disco_app_recurring_application_charges", "disco_app_subscriptions", column: "subscription_id"
    add_foreign_key "disco_app_sessions", "disco_app_shops", column: "shop_id", on_delete: :cascade
    add_foreign_key "disco_app_subscriptions", "disco_app_plan_codes", column: "plan_code_id"
  end

end
