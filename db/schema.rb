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

ActiveRecord::Schema.define(:version => 20120504022529) do

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

  create_table "people", :force => true do |t|
    t.string   "firstname"
    t.string   "middlename"
    t.string   "lastname"
    t.string   "entityname"
    t.string   "type"
    t.string   "streetaddress"
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
    t.integer  "relationtype"
    t.string   "relationdetail"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.integer  "person_id"
    t.string   "session_token"
    t.string   "password_digest"
    t.boolean  "email_validated", :default => false
    t.boolean  "admin_approved",  :default => true
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

end
