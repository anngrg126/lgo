class Story < ApplicationRecord
  extend FriendlyId
  friendly_id :generate_friendly_id, :use => [:slugged, :finders]
  
  validates :raw_title, presence: true
  validates :raw_body, presence: true
  
  attr_accessor :validate_final_fields
  attr_accessor :validate_updated_fields
  attr_accessor :validate_main_image
  attr_accessor :validate_all_tags
  
  def validate_final_fields?
    validate_final_fields == 'true' || validate_final_fields == true
  end
  def validate_updated_fields?
    validate_updated_fields == 'true' || validate_updated_fields == true
  end
  def validate_main_image?
    validate_main_image == 'true' || validate_main_image == true
  end
  def validate_all_tags?
    validate_all_tags == 'true' || validate_all_tags == true
  end
    
  validate :check_all_tags?, if: :validate_all_tags?
  
  def check_all_tags?
    all_tags = []
    if self.classifications.length == 0
      self.errors.add(:classifications, "You need tags.")
    else
      self.classifications.each do |classifi|
        tag = Tag.find(classifi.tag_id)
        all_cats.push(tag.tag_category_id)
        if tag.tag_category_id == 5 || tag.tag_category_id == 2
          all_tags.push(classifi.tag_id)
        end
      end
      unless all_cats.include?(5)
        self.errors.add(:classifications, "Story must have at least one Recipient tag")
      end
      unless all_cats.include?(2)
        self.errors.add(:classifications, "Story must have at least one Occasion tag")
      end

      sub_classi = []
      all_tags.each do |x|
        sub_classi.push(self.classifications.where(tag_id: x))
      end
      primary_recipient = 0
      primary_occasion = 0
      sub_classi.each do |y|
        y.each do |z|
          if z.primary == true && Tag.find(z.tag_id).tag_category_id == 5
            primary_recipient += 1
          end
          if z.primary == true && Tag.find(z.tag_id).tag_category_id == 2
            primary_occasion += 1
          end
        end
      end
      if primary_recipient == 0
        self.errors.add(:classifications, "Story must have at least one primary Recipient tag")
      elsif primary_recipient > 1
        self.errors.add(:classifications, "Story cannot have more than one primary Recipient tag")
      end
      if primary_occasion == 0
        self.errors.add(:classifications, "Story must have at least one primary Occasion tag")
      elsif primary_occasion > 1
        self.errors.add(:classifications, "Story cannot have more than one primary Occasion tag")
      end
    end
  end
    
  validates :final_title, presence: true, length: {maximum: 90}, if: :validate_final_fields?
  validates :final_body, presence: true, if: :validate_final_fields?
  validates :updated_title, presence: true, if: :validate_updated_fields?
  validates :updated_body, presence: true, if: :validate_updated_fields?
  
  belongs_to :user
  
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :reaction_categories, through: :reactions
  has_many :classifications, dependent: :destroy
  has_many :tags, through: :classifications

  accepts_nested_attributes_for :pictures, limit: 15, reject_if: :all_blank
  validates_associated :pictures
  
  accepts_nested_attributes_for :classifications
  
  has_attached_file :main_image, styles: {
    medium: '600x314>', 
    large: '1200x628>' 
  }
  
  validates_attachment :main_image, :content_type => { content_type: ["image/jpeg", "image/jpg", "image/gif", "image/png"] }, :size => { in: 0..1.megabytes }, :presence => true, if: :validate_main_image?
  
  default_scope { order(created_at: :desc)}
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :active, -> { where(deleted_at: nil) }
  
  def should_generate_new_friendly_id?
    final_title_changed? || updated_title_changed? || raw_title_changed? || super
  end
  
  def generate_friendly_id
    if self.published?
      if self.last_user_to_update == "Author"
        [:updated_title, :id]
      elsif self.last_user_to_update == "Admin"
        [:final_title, :id]
      else
        [:raw_title, :id]
      end
    else
      [:id]
    end
  end
end