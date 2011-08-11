class Image < ActiveRecord::Base
  include Paperclip
  belongs_to :imageable, :polymorphic => true
  has_attached_file :photo,
    :styles => {
      :thumb=> "100x100",
      :small  => "200x200>",
      :medium => "300x300>",
      :large =>   "400x400>" }
  
end
