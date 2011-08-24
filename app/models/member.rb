class Member < ActiveRecord::Base
  belongs_to :group
  has_one :user
  has_one :image, :as => :imageable, :dependent => :destroy
  has_many :rounds, :order => "date DESC", :dependent => :destroy
  has_many :quotas,  :dependent => :destroy
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :allow_blank => true, :allow_nil => true
  validates_numericality_of :quota,  :only_integer => true, :greater_than => 1, :less_than => 45
  validates_numericality_of :initial_quota,  :only_integer => true, :greater_than => 1, :less_than => 45
  validates_presence_of :tee
  validates_presence_of :first_name
  before_validation :set_defaults
  
  #has_one :image, :as => :imageable
 # has_many :rounds, :order => "date DESC", :dependent => :destroy
  #has_many :quotas,  :dependent => :destroy
  
  def self.get_members(group)
    group.members  #.where(:status => ["Active","Inactive"])
  end
  def self.get_active_members(group)
    group.members.where(['last_played >= ?  AND status != ? AND status != ?', (Date.today - 90.days),'Deleted', 'Hidden'])
  end
  def self.get_inactive_members(group)
    group.members.where(['((last_played < ?) OR (last_played is NULL)) AND status != ? AND status != ?',  (Date.today - 90.days),'Deleted','Hidden'])
  end
  def self.get_deleted_members(group)
    group.members.where(:status => ['Deleted','Hidden'])
  end
  
 # validates_presence_of   :last_played 
 # validates_numericality_of :quota,  :only_integer => true, :greater_than => 1, :less_than => 45

  
  def set_defaults
    self.status = "Active" if self.status.nil?
    self.initial_quota = self.quota if self.initial_quota.nil?
  end 
  
  def update_quota
    quota, limited, last_played, current_rounds = self.compute_tee_quota(0)
    self.quota = quota
    self.last_played = last_played
    self.limited = limited
		self.save
  end

  def update_member_quotas
      tees = Round.where(:member_id => self.id).select("DISTINCT(tee_id)")
      tees.each do |tee|
        self.compute_tee_quota(tee.tee_id)
      end
      self.update_quota
    return true
  end  
  def name
    self.first_name + " " + self.last_name
  end
  
  def invite_user
    user = self.build_user(:group_id => self.group_id,:email => self.email, :member_id => self.id)
    user.roles = ["member"]
    user.generate_token(:token,"iv")
    user.token_expires = Time.zone.now + 86400 * 5
    user.save :validate => false
    UserMailer.invite_member(user).deliver  
  end
  
  def compute_tee_quota(tee=0)
    group = self.group
    # ** Comment **
    # first get the last_played date and the rounds that will be used for the calculation
    # ** End Comment **
    last_played = nil

    if group.uses_best_rounds
      perc =  group.best_rounds_minimum.to_f / group.best_rounds_maximum.to_f
      if tee > 0
        therounds = Round.where(:member_id => self.id, :tee_id => tee).order("date DESC").limit(group.best_rounds_maximum)
      else
        therounds = Round.where(:member_id => self.id).order("date DESC").limit(group.best_rounds_maximum)
      end
      cnt = therounds.count
      round_limit = cnt < group.best_rounds_maximum ? (cnt * perc).ceil : group.best_rounds_minimum
      last_played = therounds.size > 0 ? therounds.first.date : nil
      theroundids = therounds.select(:id).all
      therounds = Round.where("id in (?)",theroundids).order("points_pulled DESC").limit((round_limit + 1))
      theroundids = therounds.select(:id).all
      therounds = Round.where("id in (?)",theroundids).order("date DESC")
      quota_limit = group.round_limit
    else
      if tee > 0
        therounds = Round.where(:member_id => self.id, :tee_id => tee).order("date DESC").limit((group.rounds_used + 1))
      else
        therounds = Round.where(:member_id => self.id).order("date DESC").limit((group.rounds_used + 1))
      end
      last_played = therounds.size > 0 ? therounds.first.date : nil
      quota_limit = group.rounds_used
      
    end
    # ** Comment **
    # set some inital values and then calculate the quota, taking into account preferences
    # ** End Comment **

    round_count = therounds.size
    total = 0.0
    current_rounds = []
    cnt = 0
    star = false
    if round_count <=  0
      quota = self.quota
      rounds_used = 0
    else
      max = 0
      min = 100
      for around in therounds
        current_rounds[cnt] = around.points_pulled.to_s
        if cnt < quota_limit # zero based
          if around.points_pulled != nil
            total += around.points_pulled
            max = around.points_pulled > max ? around.points_pulled : max
            min = around.points_pulled < min ? around.points_pulled : min
          end
        end
        cnt += 1
      end
      rounds_used = cnt > quota_limit ?  quota_limit : round_count
      divisor = rounds_used
      if group.uses_high_low_rounds_rule && rounds_used > group.high_low_rounds_effective
        divisor -= 2
        total = total - min - max
      end
      quota = total / divisor
    end
    # ** Comment **
    # if the star preferece is used, set the star to true or false.
    # star will always be false if preference not set 
    # ** End Comment **

    if tee > 0
      if group.uses_new_course_limit
        star = rounds_used < group.new_member_rounds_used ? true : false
      end
    else
      if group.uses_new_member_limit
        star = rounds_used < group.new_member_rounds_used ? true : false
      end
    end

    # TODO need to add field quota claimed that does not change
    if (rounds_used < group.new_member_rounds_used)  &&  !self.initial_quota.nil? && (self.initial_quota > 0) # average claimed (or quota for all course) with single round score
      quota = (quota + self.initial_quota) / 2
    end

    quota = (quota + 0.5).to_i
    if quota <= 0
      quota = 18
    end
    # ** Comment **
    # save the calculations in the Quoto model if there are rounds
    # ** End Comment **
    #TODO THIS NEEDS TO MOVE TO UPDATE OR CREATE FOR ROUNDS, THINK CONVERSION KLUDGE
    #BUT THEN IF IT IS NOT CHANGED, IT DOES NOT DO AN UPDATE

    if round_count > 0
      q = Quota.find_or_create_by_member_id_and_tee_id(self.id,tee)
      q.quota = quota
      q.limited = star
      q.last_played = last_played
      q.history = current_rounds.to_json
      q.save
    end
    return quota,star,last_played,current_rounds

  end

  def get_member_quota(tee=0)
    group = self.group

    q = Quota.where(:member_id => self.id, :tee_id => tee).first

    if q.nil?
      if (tee > 0) and group.uses_new_course_limit
        return self.quota, true,nil,nil
      else
        return self.quota, self.limited,nil,nil
      end
    else
      return q.quota, q.limited, q.last_played, q.history_from_json
    end
  end

  def get_current_history(m,g,c=nil)
	
    hist = []
    all =  m.get_member_quota(0)
    if !all[2].nil?
      all << 'All'
      all << "<a href=\"?All\">All</a>".html_safe
      all << m.tee
      all << c
      hist << all
      # fix 
		  if  ((m.quota != all[0]) or  (m.last_played != all[3]))
		    m.quota = all[0]
		    m.last_played = all[2]
		    m.save
		  end

    end

    courses = Course.where(:group_id => m.group_id)
    for course in courses
      tees = course.tees
      for tee in tees
        arr = m.get_member_quota(tee.id)
        if !arr[2].nil?
          arr << course.name
          arr << "<a href=\"?tee=#{tee.id}\">#{tee.color}</a>".html_safe
          arr << tee.tee+tee.color[0..0]
          arr << course.id
          hist << arr
        end
      end
    end
    return hist
  end

end
