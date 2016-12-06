class ClassificationExistValidator < ActiveModel::Validator
  
  
  def initialize(story)
    @story = story
  end
  
  binding.pry
  
  def validate
    if @story.classifications.empty?
      @story.errors[:classifications] << "You must have tags"
      
#    unless record.tag_id.class == "Array"
##      binding.pry
#      record.errors[:tag_id] << "ERROR ERROR ERROR ERROR ERROR"
    end
  end
end