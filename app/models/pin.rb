class Pin < ApplicationRecord
  belongs_to :user
  acts_as_votable

  has_attached_file :image, :styles => { :medium => "300x300>" }  
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
