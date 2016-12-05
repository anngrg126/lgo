class Classification < ApplicationRecord
  belongs_to :tag
  belongs_to :story
  
  attr_accessor :validate_classifications
#  binding.pry
  def validate_classifications?
    validate_classifications == 'true' || validate_classifications == true
  end
  
  validates :tag_id, presence: {:message => "Story must have at least a recipient and an occasion tag"}, if: :validate_classifications?
  
  
  
end
