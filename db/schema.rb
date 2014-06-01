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

ActiveRecord::Schema.define(:version => 20140530164841) do

  create_table "ar_users", :force => true do |t|
    t.string "email"
    t.string "hashed_password"
    t.string "salt"
  end

  add_index "ar_users", ["email"], :name => "index_ar_users_on_email", :unique => true

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "ar_users_id"
  end

  create_table "companies", :force => true do |t|
    t.string "name"
    t.string "base_url"
    t.string "parser_name"
  end

  create_table "items", :force => true do |t|
    t.string  "price"
    t.string  "name"
    t.string  "description"
    t.string  "store"
    t.integer "store_id"
    t.integer "category_id"
  end

  create_table "user_stores", :force => true do |t|
    t.integer "store_id"
    t.integer "companies_id"
    t.integer "ar_users_id"
  end

end
