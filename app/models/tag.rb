class Tag < ApplicationRecord
  belongs_to :tag_category
  
  validates :name, uniqueness: true, unless: 'name == "other"'
  
  has_many :classifications
  has_many :stories, through: :classifications
  
  scope :alltags, -> {includes(:tag_category)}
  
#  scope :relationship, -> { joins(:tag_category).where(tag_categories: { category: 'Relationship' }) }
#  scope :occasion, -> { joins(:tag_category).where(tag_categories: { category: 'Occasion' }) }
#  scope :type, -> { joins(:tag_category).where(tag_categories: { category: 'Type' }) }
#  scope :interests, -> { joins(:tag_category).where(tag_categories: { category: 'Interests' }) }
#  scope :recipient, -> { joins(:tag_category).where(tag_categories: { category: 'To_recipient' }) }
#  scope :gifton_reaction, -> { joins(:tag_category).where(tag_categories: { category: 'Gifton_reaction' }) }
#  scope :collection, -> { joins(:tag_category).where(tag_categories: { category: 'Collection' }) }
end
