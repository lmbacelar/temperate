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

ActiveRecord::Schema.define(:version => 20121114202125) do

  create_table "rtds", :force => true do |t|
    t.string   "name",                                       :null => false
    t.decimal  "r0",         :default => 100.0,              :null => false
    t.decimal  "a",          :default => 0.0039083,          :null => false
    t.decimal  "b",          :default => -0.0000005775,      :null => false
    t.decimal  "c",          :default => -0.000000000004183, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "rtds", ["name"], :name => "index_rtds_on_name", :unique => true

  create_table "sprts", :force => true do |t|
    t.string   "name",                         :null => false
    t.decimal  "rtpw",       :default => 25.0, :null => false
    t.integer  "range",      :default => 11,   :null => false
    t.decimal  "a",          :default => 0.0,  :null => false
    t.decimal  "b",          :default => 0.0,  :null => false
    t.decimal  "c",          :default => 0.0,  :null => false
    t.decimal  "d",          :default => 0.0,  :null => false
    t.decimal  "w660",       :default => 0.0,  :null => false
    t.decimal  "c1",         :default => 0.0,  :null => false
    t.decimal  "c2",         :default => 0.0,  :null => false
    t.decimal  "c3",         :default => 0.0,  :null => false
    t.decimal  "c4",         :default => 0.0,  :null => false
    t.decimal  "c5",         :default => 0.0,  :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "sprts", ["name"], :name => "index_sprts_on_name", :unique => true

  create_table "thermocouples", :force => true do |t|
    t.string   "name",                        :null => false
    t.string   "kind",       :default => "k", :null => false
    t.decimal  "a3",         :default => 0.0, :null => false
    t.decimal  "a2",         :default => 0.0, :null => false
    t.decimal  "a1",         :default => 0.0, :null => false
    t.decimal  "a0",         :default => 0.0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "thermocouples", ["name"], :name => "index_thermocouples_on_name", :unique => true

end
