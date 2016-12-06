class Classification < ApplicationRecord
  belongs_to :tag
  belongs_to :story
  
#  attr_accessor :validate_classifications
##  binding.pry
#  def validate_classifications?
#    validate_classifications == 'true' || validate_classifications == true
#  end
  
  
  
  
  
#  binding.pry
#  validates :tag_id, presence: true, length: {minimum: 1, :message => "Story must have at least a recipient and an occasion tag"}, if: :validate_classifications?
  
#  uniqueness: {"Already have an #{Tag.find(:tag_id).name} #{TagCategory.find(Tag.find(:tag_id).tag_category_id).description} tag"}
  
#  include ActiveModel::Validations
#  validates_with ClassificationValidator# if: :validate_classifications
  
#  validate :check_all_classifications, if: :validate_classifications?
  
  def check_all_classifications(array)
    binding.pry
    
  end
  
  
  
  
end
