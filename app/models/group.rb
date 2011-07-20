class Group < ActiveRecord::Base
  has_many :users
  has_many :members
  
  validates_presence_of :subdomain
  validates_format_of :subdomain, :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false

  before_validation :downcase_subdomain
  validates_exclusion_of :subdomain, :in => %w( support blog www billing help api ), :message => "The subdomain <strong>{{value}}</strong> is reserved and unavailable."
  accepts_nested_attributes_for :users, :allow_destroy => true
  accepts_nested_attributes_for :members, :allow_destroy => true
  
  after_create :link_member

  
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