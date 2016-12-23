class Tag < ApplicationRecord
  belongs_to :tag_category
  
  validates :name, uniqueness: true, unless: 'name == "other"'
  
  has_many :classifications
  has_many :stories, through: :classifications
  
  scope :alltags, -> {includes(:tag_category)}
  
  # scope :relationship, -> { alltags.select { |tag| tag.tag_category.category == "Relationship" }.sort_by {|t| t.name}}
  # scope :occasion, -> { alltags.select { |tag| tag.tag_category.category == "Occasion" }.sort_by {|t| t.name}}
  # scope :type, -> { alltags.select { |tag| tag.tag_category.category == "Type" }.sort_by {|t| t.name}}
  # scope :interests, -> { alltags.select { |tag| tag.tag_category.category == "Interests" }.sort_by {|t| t.name}}
  # scope :recipient, -> { alltags.select { |tag| tag.tag_category.category == "To_recipient" }.sort_by {|t| t.name}}
  # scope :gifton_reaction, -> { alltags.select { |tag| tag.tag_category.category == "Gifton_reaction" }.sort_by {|t| t.name}}
  # scope :collection, -> { alltags.select { |tag| tag.tag_category.category == "Collection" }.sort_by {|t| t.name}}
end
