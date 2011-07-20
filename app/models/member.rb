class Member < ActiveRecord::Base
  belongs_to :group
  has_one :user
  
  #has_one :image, :as => :imageable
 # has_many :rounds, :order => "date DESC", :dependent => :destroy
  #has_many :quotas,  :dependent => :destroy
  
  def self.get_members(group)
    group.members  #.where(:status => ["Active","Inactive"])
  end
  def self.get_active_members(group)
    group.members.where(['last_played >= ? AND status != ? AND status != ?', (Date.today - 90.days),'Deleted', 'Hidden'])
  end
  def self.get_inactive_members(group)
    group.members.where(['last_played < ? AND status != ? AND status != ?',  (Date.today - 90.days),'Deleted','Hidden'])
  end
  def self.get_deleted_members(group)
    group.members.where(:status => ['Deleted','Hidden'])
  end
  
=begin 
  validates_presence_of   :last_played 
  validates_numericality_of :quota,  :only_integer => true, :greater_than => 1, :less_than => 45

  
  
  def update_quota
    quota, star, last_played, current_rounds = self.compute_tee_quota(0)
    self.quota = quota
    self.last_played = last_played
    self.starred = star
		self.save
  end

  def update_member_quotas
      tees = Round.where(:member_id => self.id).select("DISTINCT(tee_id)")
      tees.each do |tee|
        self.compute_tee_quota(tee.tee_id)
      end
      self.update_quota
    return true
=end  
  def name
    self.first_name + " " + self.last_name
  end
  
  def invite_user
    user = self.build_user(:group_id => self.group_id,:email => self.email, :member_id => self.id)
    user.role_hash = ["member"]
    user.token = "iv" + SecureRandom.urlsafe_base64
    user.token_expires = Time.zone.now + 86400 * 5
    user.save :validate => false
    UserMailer.invite_member(user).deliver  
    
  end
end
