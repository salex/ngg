class User < ActiveRecord::Base
  belongs_to :group
  belongs_to :member
  has_many :articles
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :group_id, :member_id, :roles, :token

  attr_accessor :password
  before_save :prepare_password

  validates_presence_of :email
  validates_uniqueness_of :username, :allow_blank => true
  validates_uniqueness_of :email
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  before_create { generate_token(:auth_token) }  
  
  serialize :roles
    
  def generate_token(column,sa="")  
    begin  
      self[column] = sa + SecureRandom.urlsafe_base64  
    end while User.exists?(column => self[column])  
  end  
  
 
  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end
  
  def name 
    self.member.name if self.member
  end
  
  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end
  
  def confirm
    self.confirmed_at = Time.zone.now
    self.token = nil
    self.token_expires = nil
    self.save
  end
  
  def self.single_access(token)
    u = User.find_by_token(params[:id])
    if u
      tn = Time.zone.now
      if tn > self.token_expires
        u = nil
      end
    end
    return u
  end
  
  def role?(role)
    if self.roles.blank?
      return false
    else 
      if role.class != Array
        if self.roles.class == Array
          return self.roles.include?(role.to_s.downcase)
        else
          return self.roles == (role.to_s.downcase)
        end
      else
        ok = false
        role.each do |r|
          if self.roles.class == Array
            ok = true if self.roles.include?(r.to_s.downcase)
          else
            ok = true if self.roles == (r.to_s.downcase)
          end
        end
        return ok
      end
    end
  end
  
  def admin?
    self.role? [:super,:coordinator, :admin]
    
  end
  
  def send_password_reset  
    generate_token(:token)  
    self.token = "rp"+ self.token
    self.token_expires = Time.zone.now  + 86400 
    save!  
    UserMailer.password_reset(self).deliver  
  end  
  
  

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end
