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

ActiveRecord::Schema.define(:version => 20110905133803) do

  create_table "articles", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.boolean  "published"
    t.datetime "published_at"
    t.string   "type_article"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.integer  "group_id",                 :null => false
    t.string   "name",       :limit => 30
    t.text     "address"
    t.string   "phone",      :limit => 12
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "group_id",      :null => false
    t.integer  "course_id",     :null => false
    t.date     "date"
    t.time     "teetime"
    t.text     "remarks"
    t.integer  "teams"
    t.integer  "places"
    t.string   "place_percent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attendees"
    t.string   "status"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "uses_multiple_courses"
    t.boolean  "uses_course_quota"
    t.boolean  "uses_best_rounds"
    t.integer  "best_rounds_minimum"
    t.integer  "best_rounds_maximum"
    t.integer  "rounds_used"
    t.boolean  "uses_new_member_limit"
    t.integer  "new_member_limit"
    t.integer  "new_member_rounds_used"
    t.boolean  "uses_round_limit"
    t.integer  "round_limit"
    t.boolean  "uses_new_course_limit"
    t.boolean  "uses_high_low_rounds_rule"
    t.integer  "high_low_rounds_effective"
    t.float    "round_dues"
    t.float    "skins_dues"
    t.float    "other_game"
    t.float    "other_dues"
    t.integer  "points_double_eagle"
    t.integer  "points_eagle"
    t.integer  "points_birdie"
    t.integer  "points_par"
    t.integer  "points_bogey"
    t.integer  "points_double_bogey"
    t.string   "pot_splits"
    t.integer  "trim_round_days"
    t.boolean  "limit_gross_points"
  end

  create_table "images", :force => true do |t|
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.string   "name"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.integer  "group_id"
    t.string   "email"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "phone"
    t.string   "cell"
    t.text     "address"
    t.boolean  "list_contact"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "last_played"
    t.integer  "quota"
    t.boolean  "limited"
    t.integer  "initial_quota"
    t.string   "tee",           :limit => 1
  end

  create_table "quotas", :force => true do |t|
    t.integer  "member_id"
    t.integer  "tee_id"
    t.integer  "quota"
    t.date     "last_played"
    t.text     "history"
    t.boolean  "limited"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", :force => true do |t|
    t.integer  "member_id"
    t.integer  "event_id"
    t.integer  "tee_id"
    t.date     "date"
    t.integer  "quota"
    t.integer  "points_pulled"
    t.integer  "plus_minus"
    t.string   "par_in",        :limit => 9
    t.string   "par_out",       :limit => 9
    t.integer  "score"
    t.decimal  "round_quality",              :precision => 8, :scale => 2
    t.decimal  "skin_quality",               :precision => 8, :scale => 2
    t.decimal  "other_quality",              :precision => 8, :scale => 2
    t.integer  "place"
    t.integer  "team"
    t.integer  "gross_pulled"
    t.integer  "net_pulled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tees", :force => true do |t|
    t.integer  "course_id",                                             :null => false
    t.string   "tee",        :limit => 1,                               :null => false
    t.string   "color",      :limit => 8
    t.decimal  "slope",                   :precision => 8, :scale => 1
    t.decimal  "rating",                  :precision => 4, :scale => 1
    t.string   "par_in",     :limit => 9
    t.string   "par_out",    :limit => 9
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "group_id"
    t.string   "username"
    t.string   "email"
    t.string   "login"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "token"
    t.datetime "token_expires"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "roles"
    t.integer  "member_id"
  end

end
