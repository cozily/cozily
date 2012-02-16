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

ActiveRecord::Schema.define(:version => 20120216000222) do

  create_table "apartment_features", :force => true do |t|
    t.integer  "apartment_id"
    t.integer  "feature_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apartment_features", ["apartment_id"], :name => "index_apartment_features_on_apartment_id"
  add_index "apartment_features", ["feature_id"], :name => "index_apartment_features_on_feature_id"

  create_table "apartments", :force => true do |t|
    t.integer  "building_id"
    t.integer  "rent"
    t.float    "bedrooms"
    t.float    "bathrooms"
    t.integer  "square_footage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "flags_count",     :default => 0
    t.integer  "user_id"
    t.date     "start_date"
    t.string   "unit"
    t.integer  "images_count",    :default => 0
    t.boolean  "sublet",          :default => false
    t.date     "end_date"
    t.integer  "views_count",     :default => 0
    t.integer  "favorites_count", :default => 0
    t.datetime "published_at"
    t.string   "external_id"
    t.string   "external_url"
    t.string   "external_source"
    t.boolean  "imported",        :default => false, :null => false
    t.integer  "photos_count"
  end

  add_index "apartments", ["building_id"], :name => "index_apartments_on_address_id"
  add_index "apartments", ["user_id"], :name => "index_apartments_on_user_id"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "building_neighborhoods", :force => true do |t|
    t.integer  "building_id"
    t.integer  "neighborhood_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "building_neighborhoods", ["building_id"], :name => "index_address_neighborhoods_on_address_id"
  add_index "building_neighborhoods", ["neighborhood_id"], :name => "index_address_neighborhoods_on_neighborhood_id"

  create_table "buildings", :force => true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "full_address"
    t.decimal  "lat",          :precision => 15, :scale => 10
    t.decimal  "lng",          :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "accuracy"
  end

  create_table "conversations", :force => true do |t|
    t.integer  "apartment_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sender_deleted_at"
    t.datetime "receiver_deleted_at"
  end

  add_index "conversations", ["apartment_id"], :name => "index_conversations_on_apartment_id"
  add_index "conversations", ["receiver_id"], :name => "index_conversations_on_receiver_id"
  add_index "conversations", ["sender_id"], :name => "index_conversations_on_sender_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "apartment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["apartment_id"], :name => "index_favorites_on_apartment_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "features", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "flags", :force => true do |t|
    t.integer  "apartment_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags", ["apartment_id"], :name => "index_flags_on_apartment_id"
  add_index "flags", ["user_id"], :name => "index_flags_on_user_id"

  create_table "images", :force => true do |t|
    t.integer  "apartment_id"
    t.string   "caption"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "images", ["apartment_id"], :name => "index_images_on_apartment_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "read_at"
    t.integer  "conversation_id"
  end

  add_index "messages", ["conversation_id"], :name => "index_messages_on_conversation_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "neighborhood_profiles", :force => true do |t|
    t.integer  "neighborhood_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "neighborhood_profiles", ["neighborhood_id"], :name => "index_neighborhood_profiles_on_neighborhood_id"
  add_index "neighborhood_profiles", ["profile_id"], :name => "index_neighborhood_profiles_on_profile_id"

  create_table "neighborhoods", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "borough"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "apartment_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["apartment_id"], :name => "index_notifications_on_apartment_id"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "nyc_buildings", :force => true do |t|
    t.string "boro",      :limit => 1
    t.string "block",     :limit => 5
    t.string "lot",       :limit => 4
    t.string "bin",       :limit => 7
    t.string "lhnd",      :limit => 12
    t.string "lhns",      :limit => 11
    t.string "lcontpar",  :limit => 1
    t.string "lsos",      :limit => 1
    t.string "hhnd",      :limit => 12
    t.string "hhns",      :limit => 11
    t.string "hcontpar",  :limit => 1
    t.string "hsos",      :limit => 1
    t.string "scboro",    :limit => 1
    t.string "sc5",       :limit => 5
    t.string "sclgc",     :limit => 2
    t.string "stname",    :limit => 32
    t.string "addrtype",  :limit => 1
    t.string "realb7sc",  :limit => 8
    t.string "validlgcs", :limit => 8
    t.string "parity",    :limit => 1
    t.string "b10sc",     :limit => 11
    t.string "segid",     :limit => 7
  end

  create_table "nyc_tax_lots", :force => true do |t|
    t.string "loboro",     :limit => 1
    t.string "loblock",    :limit => 5
    t.string "lolot",      :limit => 4
    t.string "lobblssc",   :limit => 1
    t.string "hiboro",     :limit => 1
    t.string "hiblock",    :limit => 5
    t.string "hilot",      :limit => 4
    t.string "hibblssc",   :limit => 1
    t.string "boro",       :limit => 1
    t.string "block",      :limit => 5
    t.string "lot",        :limit => 4
    t.string "bblssc",     :limit => 1
    t.string "billboro",   :limit => 1
    t.string "billblock",  :limit => 5
    t.string "billlot",    :limit => 4
    t.string "billbblssc", :limit => 1
    t.string "condoflag",  :limit => 1
    t.string "condonum",   :limit => 4
    t.string "coopnum",    :limit => 4
    t.string "numbf",      :limit => 2
    t.string "numaddr",    :limit => 4
    t.string "vacant",     :limit => 1
    t.string "interior",   :limit => 1
  end

  create_table "photos", :force => true do |t|
    t.integer  "apartment_id"
    t.string   "image"
    t.string   "caption"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_features", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "feature_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bedrooms"
    t.integer  "rent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sublets",    :default => 0
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "station_trains", :force => true do |t|
    t.integer  "station_id"
    t.integer  "train_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "station_trains", ["station_id"], :name => "index_station_trains_on_station_id"
  add_index "station_trains", ["train_id"], :name => "index_station_trains_on_train_id"

  create_table "stations", :force => true do |t|
    t.string   "name"
    t.decimal  "lat",         :precision => 15, :scale => 10
    t.decimal  "lng",         :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "line"
    t.string   "train_group"
  end

  create_table "timeline_events", :force => true do |t|
    t.string   "event_type"
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timeline_events", ["actor_id", "actor_type"], :name => "index_timeline_events_on_actor_id_and_actor_type"
  add_index "timeline_events", ["secondary_subject_id", "secondary_subject_type"], :name => "index_timeline_events_on_ss_id_and_ss_type"
  add_index "timeline_events", ["subject_id", "subject_type"], :name => "index_timeline_events_on_subject_id_and_subject_type"

  create_table "trains", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_activities", :force => true do |t|
    t.integer  "user_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_activities", ["user_id"], :name => "index_user_activities_on_user_id"

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], :name => "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",          :limit => 128
    t.string   "salt",                        :limit => 128
    t.string   "remember_token",              :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.boolean  "receive_match_notifications",                :default => true
    t.boolean  "receive_match_summaries",                    :default => true
    t.boolean  "receive_listing_summaries",                  :default => true
    t.boolean  "is_admin",                                   :default => false, :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
