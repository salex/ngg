class Course < ActiveRecord::Base
  belongs_to :group
  has_many :tees, :dependent => :destroy
  
end
