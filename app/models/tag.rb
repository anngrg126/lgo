class Tag < ApplicationRecord
  belongs_to :tag_category
  
  validates :name, uniqueness: true
end
