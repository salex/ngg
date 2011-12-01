class Group < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :members, :order => 'first_name , last_name', :dependent => :destroy
  has_many :courses, :order => :id, :dependent => :destroy
  has_many :articles, :order => 'published_at DESC', :dependent => :destroy
  has_many :events, :order => 'date DESC', :dependent => :destroy
  has_many :images, :as => :imageable, :dependent => :destroy
  validates_numericality_of :trim_round_days,  :only_integer => true, :greater_than => 179
  
  
  validates_presence_of :subdomain
  validates_format_of :subdomain, :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false

  before_validation :downcase_subdomain
  validates_exclusion_of :subdomain, :in => %w( support blog www billing help api ), :message => "The subdomain <strong>{{value}}</strong> is reserved and unavailable."
  accepts_nested_attributes_for :users, :allow_destroy => true
  accepts_nested_attributes_for :members, :allow_destroy => true
  
  
  def new_group
    result = self.save
    if result 
      mid, uid = self.link_member
      a = Article.new
      a.group_id = self.id
      a.user_id = uid
      a.body = "**Who**\r\n\r\n**What**\r\n\r\n**Where**\r\n\r\n**When**\r\n\r\n**Why**\r\n"
      a.title = "About " + self.name
      a.type_article = "Welcome"
      a.save
      UserMailer.register_group(uid).deliver  
      
    end
    return result
  end

	def options
		options = {}
		options["uses_multiple_courses"] = self["uses_multiple_courses"]
		options["uses_course_quota"] = self["uses_course_quota"]
		options["uses_best_rounds"] = self["uses_best_rounds"]
		options["best_rounds_minimum"] = self["best_rounds_minimum"]
		options["best_rounds_maximum"] = self["best_rounds_maximum"]
		options["rounds_used"] = self["rounds_used"]
		options["uses_new_member_limit"] = self["uses_new_member_limit"]
		options["new_member_limit"] = self["new_member_limit"]
		options["new_member_rounds_used"] = self["new_member_rounds_used"]
		options["uses_round_limit"] = self["uses_round_limit"]
		options["round_limit"] = self["round_limit"]
		options["uses_new_course_limit"] = self["uses_new_course_limit"]
		options["uses_high_low_rounds_rule"] = self["uses_high_low_rounds_rule"]
		options["high_low_rounds_effective"] = self["high_low_rounds_effective"]
		options["round_dues"] = self["round_dues"]
		options["skins_dues"] = self["skins_dues"]
		options["other_game"] = self["other_game"]
		options["other_dues"] = self["other_dues"]
		options["points_double_eagle"] = self["points_double_eagle"]
		options["points_eagle"] = self["points_eagle"]
		options["points_birdie"] = self["points_birdie"]
		options["points_par"] = self["points_par"]
		options["points_bogey"] = self["points_bogey"]
		options["points_double_bogey"] = self["points_double_bogey"]
		options["scoreValues"] = [self["points_double_eagle"],self["points_eagle"],self["points_birdie"],self["points_par"],self["points_bogey"],self["points_double_bogey"]]
		options["pot_splits"] = self["pot_splits"]
		options["trim_round_days"] = self["trim_round_days"]
		return options
	end
	
	def splitPot(count,places)
	  pot = self.round_dues * count
    if places > 5
      return []
    end
    arr = self.pot_splits
    splits = eval("[#{arr}]")
    split = splits[places - 1]
    money = []
    amt = 0
    for i in 0..split.length-1 do
      money[i] = ((split[i] / 100.0) * pot).round
      amt += money[i]
    end
    if (amt != pot) 
      dif = pot - amt
      money[0] += dif
    end
    money.insert(0,pot)
    return money
  end
  
	
	def recompute_members_quotas
    members = self.members
    members.each do |member|
      tees = Round.where(:member_id => member.id).select("DISTINCT(tee_id)")
      tees.each do |tee|
        member.compute_tee_quota(tee.tee_id)
      end
      member.update_quota
    end
    return true
  end
  

  protected

    
    def downcase_subdomain
      self.subdomain.downcase! if attribute_present?("subdomain")
    end
    
    def link_member
      member = self.members.first
      user = self.users.first
      user.member_id = member.id
      user.roles = ["coordinator","admin"]
      user.generate_token(:token,"rg")
      user.token_expires = Time.zone.now + 86400 * 5
      user.save
      return member.id, user.id
    end
  
end



