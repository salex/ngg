class CreateTeesAndCourses < ActiveRecord::Migration
  def change
    create_table "tees" do |t|
      t.integer  "course_id",                                             :null => false
      t.string   "tee",        :limit => 1,                               :null => false
      t.string   "color",      :limit => 8
      t.decimal  "slope",                   :precision => 8, :scale => 1
      t.decimal  "rating",                  :precision => 4, :scale => 1
      t.string   "par_in",     :limit => 9
      t.string   "par_out",    :limit => 9

      t.timestamps
    end
    
    create_table "courses" do |t|
      t.integer  "group_id",                 :null => false
      t.string   "name",       :limit => 30
      t.text     "address"
      t.string   "phone",      :limit => 12
      t.string   "link"
      t.timestamps
      
    end
    
    create_table "events" do |t|
      t.integer  "group_id",      :null => false
      t.integer  "course_id",     :null => false
      t.date     "date"
      t.time     "teetime"
      t.text     "remarks"
      t.integer  "teams"
      t.integer  "places"
      t.string   "place_percent"
      t.timestamps
      
    end
    create_table "quotas" do |t|
      t.integer  "member_id"
      t.integer  "tee_id"
      t.integer  "quota"
      t.date     "lastplayed"
      t.boolean  "stared"
      t.text     "history"
      t.timestamps
    
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
      t.decimal  "other_quality",               :precision => 8, :scale => 2
      t.integer  "place"
      t.integer  "team"
      t.integer  "gross_pulled"
      t.integer  "net_pulled"
      t.timestamps
      
    end
    
    
    
    
  end

end
