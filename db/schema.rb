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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120519152031) do

  create_table "capitalization_records", :force => true do |t|
    t.integer  "capitalization_table_id"
    t.string   "description"
    t.float    "authorized_amount"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "capitalization_tables", :force => true do |t|
    t.integer  "company_id"
    t.string   "description"
    t.boolean  "actual"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city_state_zip"
    t.string   "state_of_incorporation"
    t.string   "phone"
    t.string   "fax"
    t.string   "business_description"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "equity_plans", :force => true do |t|
    t.string   "description"
    t.integer  "capitalization_record_id"
    t.float    "authorized_amount"
    t.datetime "board_approval_date"
    t.string   "stockholder_approval_date"
    t.string   "amendment_history"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "equity_records", :force => true do |t|
    t.integer  "capitalization_record_id"
    t.integer  "person_id"
    t.float    "amount"
    t.datetime "grant_date"
    t.integer  "vesting_schedule_id"
    t.string   "equity_type"
    t.integer  "relation_from_id"
    t.string   "relation_from_description"
    t.integer  "relation_to_id"
    t.string   "relation_to_description"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "entity_name"
    t.string   "type"
    t.string   "street_address"
    t.string   "city_state_zip"
    t.string   "country"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "relation_person_companies", :force => true do |t|
    t.integer  "person_id"
    t.integer  "company_id"
    t.integer  "relation_type"
    t.string   "relation_detail"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.integer  "person_id"
    t.integer  "active_company_id"
    t.string   "session_token"
    t.string   "password_digest"
    t.boolean  "email_validated",   :default => false
    t.boolean  "admin_approved",    :default => true
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

end
