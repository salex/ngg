class Quota < ActiveRecord::Base
	set_table_name "quotas"
	belongs_to :member

  def history_from_json
    return ActiveSupport::JSON.decode(self.history)
  end
  
  def is_dirty?
     dirty = false
     self.changed.each{|attrib|
       dirty =  (dirty || !( /quota|limited|last_played|history/i =~ attrib ).nil?)
     }
    return dirty
  end
  
end
