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

ActiveRecord::Schema.define(:version => 0) do

  create_table "categories", :force => true do |t|
    t.string "category_name", :limit => 45, :null => false
  end

  create_table "emails", :force => true do |t|
    t.string  "first_name",   :limit => 45, :null => false
    t.string  "last_name",    :limit => 45, :null => false
    t.string  "email",                      :null => false
    t.integer "organizer_id",               :null => false
  end

  add_index "emails", ["organizer_id"], :name => "user_organizer_fk"

  create_table "events", :force => true do |t|
    t.integer  "organizer_id",               :null => false
    t.string   "title",        :limit => 55, :null => false
    t.text     "description",                :null => false
    t.integer  "category_id",                :null => false
    t.datetime "date",                       :null => false
    t.datetime "end_date",                   :null => false
    t.integer  "start_time",                 :null => false
    t.integer  "location_id",                :null => false
    t.string   "cost",         :limit => 4,  :null => false
    t.string   "event_url"
    t.boolean  "featured"
  end

  add_index "events", ["category_id"], :name => "category_fk"
  add_index "events", ["location_id"], :name => "location_fk"
  add_index "events", ["organizer_id"], :name => "organizer_fk"

  create_table "locations", :force => true do |t|
    t.string "location_name", :null => false
    t.float  "geo_lat"
    t.float  "geo_long"
  end

  create_table "organizers", :force => true do |t|
    t.string  "user",                   :limit => 45, :null => false
    t.string  "organization",                         :null => false
    t.string  "email",                                :null => false
    t.integer "primary_event_location",               :null => false
    t.string  "event_home_page",                      :null => false
    t.string  "twitter_handle",         :limit => 45
    t.integer "user_id"
  end

  add_index "organizers", ["primary_event_location"], :name => "primary_location_fk"
  add_index "organizers", ["user_id"], :name => "user_fk"

  create_table "overlays", :force => true do |t|
    t.integer "ref_id",                 :null => false
    t.float   "lon",                    :null => false
    t.float   "lat",                    :null => false
    t.string  "name",     :limit => 45
    t.string  "amenity",  :limit => 45
    t.string  "operator", :limit => 45
    t.string  "typeof",   :limit => 45, :null => false
  end

  create_table "users", :force => true do |t|
    t.string "account",           :null => false
    t.string "crypted_password",  :null => false
    t.string "password_salt",     :null => false
    t.string "persistence_token", :null => false
  end

end
