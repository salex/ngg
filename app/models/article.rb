class Article < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  before_save :set_published
  
  
  def set_published
    if self.published
      if self.published_at.nil?
        self.published_at = Time.zone.now
      end
    end
  end
  
end
