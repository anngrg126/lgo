class Story < ApplicationRecord
  extend FriendlyId
  friendly_id :generate_friendly_id, :use => [:slugged, :finders]
  searchkick text_start: [:final_title]
  
#  validates :raw_title, presence: true
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
    if self.classifications.length == 0
      self.errors.add(:classifications, "You need tags.")
    else
      #validate that primary recipient & occasion tags exist
      primary_tags = []
      @tags = Tag.alltags
      recipient_category = @tags.select{|t| t.tag_category.category == "To_recipient"}.first.tag_category
      occasion_category = @tags.select{|t| t.tag_category.category == "Occasion"}.first.tag_category
      self.classifications.each do |c|
        if c.primary == true
          tag = @tags.select{|t| t.id == c.tag_id}.first
          primary_tags.push(tag.tag_category_id)
        end
      end
      unless primary_tags.include?(recipient_category.id)
        self.errors.add(:classifications, "Story must have only one primary Recipient tag")
      end
      unless primary_tags.include?(occasion_category.id)
        self.errors.add(:classifications, "Story must have only one primary Occasion tag")
      end
      #validate that fail tags are aligned with fail boolean
      @fail_tag = @tags.select{|t| t.name == "fail"}.first
      unless self.classifications.select{|c| c.tag_id == @fail_tag.id}.empty?
        unless self.fail?
          self.errors.add(:classifications, "You have added a fail tag to a story that is not specified as a fail. To continue, specify above that this story is a fail.")
        end
      else
        if self.fail?
          self.errors.add(:classifications, "You have not added a fail tag to a story that is specified as a fail. To continue, specify above that this story is not a fail.")
        end
      end
    end
  end
    
  validates :final_title, presence: true, length: {maximum: 60}, if: :validate_final_fields?
  validates :final_body, presence: true, if: :validate_final_fields?
  validates :final_gift_description, presence: true, length: {maximum: 110}, if: :validate_final_fields?
  validates :updated_title, presence: true,length: {maximum: 60}, if: :validate_updated_fields?
  validates :updated_body, presence: true, if: :validate_updated_fields?
  validates :updated_gift_description, presence: true, length: {maximum: 110}, if: :validate_updated_fields?
  
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
  
  after_commit :reindex_story
  
  def reindex_story
    Story.reindex # or reindex_async
  end
  
  def should_index?
    deleted_at.nil? # only index active records
  end
  
  def active?
    deleted_at.nil?
  end
  
  def search_data
   attrs = attributes.dup
   relational = {
     # tags: tags.map(&:name)
     tags: tags.map { |t| t.name =='other' ? classifications.where(tag_id: t.id).first.description : t.name }
   }
   attrs.merge! relational
  end
  
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