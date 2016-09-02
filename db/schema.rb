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

ActiveRecord::Schema.define(version: 20160901231409) do

  create_table "contexts", force: :cascade do |t|
    t.string   "name"
    t.string   "navigation_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "customer_values", force: :cascade do |t|
    t.string   "name"
    t.integer  "operation_id"
    t.integer  "recency"
    t.integer  "frequency"
    t.integer  "satisfaction"
    t.string   "strategy"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "navigation_id"
    t.string   "text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "navigation_contexts", force: :cascade do |t|
    t.integer  "navigation_id"
    t.integer  "context_id"
    t.string   "value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "navigation_operations", force: :cascade do |t|
    t.integer  "navigation_id"
    t.integer  "operation_id"
    t.datetime "time_to_execute"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "navigations", force: :cascade do |t|
    t.string   "locale"
    t.integer  "timezone"
    t.string   "gender"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "sender_id"
    t.string   "navigation_type"
    t.integer  "destination_store_id"
    t.string   "recommendations"
    t.integer  "arrived"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "operations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "senders", force: :cascade do |t|
    t.string   "facebook_id"
    t.integer  "navigation_id"
    t.integer  "customer_value_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "store_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "store_id"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "image_uri"
    t.string   "name"
    t.string   "opening_hour"
    t.string   "phone_number"
    t.string   "category"
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
