class Story < ApplicationRecord
  validates :raw_title, presence: true
  validates :raw_body, presence: true
  
  attr_accessor :validate_final_fields
  attr_accessor :validate_updated_fields
  attr_accessor :validate_main_image
  def validate_final_fields?
    validate_final_fields == 'true' || validate_final_fields == true
  end
  def validate_updated_fields?
    validate_updated_fields == 'true' || validate_updated_fields == true
  end
  def validate_main_image?
    validate_main_image == 'true' || validate_main_image == true
  end
  validates :final_title, presence: true, length: {maximum: 90}, if: :validate_final_fields?
  validates :final_body, presence: true, if: :validate_final_fields?
  validates :updated_title, presence: true, if: :validate_updated_fields?
  validates :updated_body, presence: true, if: :validate_updated_fields?
  
  belongs_to :user
  
  has_many :comments, dependent: :destroy  # If story gets deleted, the depending comment also gets deleted
  has_many :bookmarks, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :reaction_categories, through: :reactions

  accepts_nested_attributes_for :pictures, limit: 15, reject_if: :all_blank
  validates_associated :pictures
  
  has_attached_file :main_image, styles: {
    medium: '600x314>', 
    large: '1200x628>' 
  }
  
  validates_attachment :main_image, :content_type => { content_type: ["image/jpeg", "image/jpg", "image/gif", "image/png"] }, :size => { in: 0..1.megabytes }, :presence => true, if: :validate_main_image?
  
  default_scope { order(created_at: :desc)}
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
end