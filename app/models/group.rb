class Group < ActiveRecord::Base
  has_many :users
  has_many :members, :order => 'first_name , last_name'
  has_many :courses, :order => :id
  has_many :articles, :order => 'published_at DESC'
  has_many :events, :order => 'date DESC'
  has_many :images, :as => :imageable
  has_many :users #, :foreign_key => :subdomain, :primary_key => :subdomain
  
  
  validates_presence_of :subdomain
  validates_format_of :subdomain, :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false

  before_validation :downcase_subdomain
  validates_exclusion_of :subdomain, :in => %w( support blog www billing help api ), :message => "The subdomain <strong>{{value}}</strong> is reserved and unavailable."
  accepts_nested_attributes_for :users, :allow_destroy => true
  accepts_nested_attributes_for :members, :allow_destroy => true
  
  #after_create :link_member

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
		options["pot_splits"] = self["pot_splits"]
		return options
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
      user.save
    end
  
end

=begin
def recompute_user_quotas
  users = User.where(:group_id => self.id)
  users.each do |user|
    tees = Round.where(:user_id => user.id).select("DISTINCT(tee_id)")
    tees.each do |tee|
      user.compute_tee_quota(tee.tee_id)
    end
    user.update_quota
  end
  return true
end



=end