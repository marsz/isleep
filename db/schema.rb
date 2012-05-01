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

ActiveRecord::Schema.define(:version => 20120501083722) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkins", :force => true do |t|
    t.integer  "user_id"
    t.date     "date"
    t.string   "check_type"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkins", ["check_type"], :name => "index_checkins_on_check_type"
  add_index "checkins", ["date", "check_type"], :name => "index_checkins_on_date_and_check_type"
  add_index "checkins", ["date"], :name => "index_checkins_on_date"
  add_index "checkins", ["user_id", "check_type"], :name => "index_checkins_on_user_id_and_check_type"
  add_index "checkins", ["user_id", "date", "check_type"], :name => "index_checkins_on_user_id_and_date_and_check_type"
  add_index "checkins", ["user_id", "date"], :name => "index_checkins_on_user_id_and_date"
  add_index "checkins", ["user_id"], :name => "index_checkins_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "name"
    t.string   "encrypted_password",     :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "sleep_target"
    t.integer  "sp",                     :default => 0
    t.time     "wakeup_target"
    t.integer  "hp",                     :default => 0
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
