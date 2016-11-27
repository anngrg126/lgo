class Tag < ApplicationRecord
  belongs_to :tag_category
  
  validates :name, uniqueness: true
  
  has_many :classifications
  has_many :stories, through: :classifications
end
