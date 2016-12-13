class TagCategory < ApplicationRecord
  has_many :tags
  validates :category, uniqueness: true
end
