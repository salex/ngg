class Tee < ActiveRecord::Base
  belongs_to :course
  has_many :rounds
  
  def self.get_tee(id)
    find(id)
  end
  
  def self.get_tees(course_id)
    
    where(:course_id => course_id).order(:id)
  end
  
end
