class User < ActiveRecord::Base
  belongs_to :group
  belongs_to :member
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :group_id, :member_id, :role_hash

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
    
  def generate_token(column)  
    begin  
      self[column] = SecureRandom.urlsafe_base64  
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
  
  def role_hash=(data)
    # make sure were providing a hash
    data = ["#{data}"] unless data.is_a?(Array)

    # convert to json
    self[:roles] = data.to_json
  end
  
  def role_hash
    hash = ActiveSupport::JSON.decode(self.roles)
  end
  
  def role?(role)
    if self.roles.blank?
      return false
    else 
      if role.class != Array
        return self.roles.downcase.include?(role.to_s.downcase)
      else
        ok = false
        role.each do |r|
          ok = true if self.roles.downcase.include?(r.to_s.downcase)
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
