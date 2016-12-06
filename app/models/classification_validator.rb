class ClassificationValidator < ActiveModel::Validator
  def validate(record)
    unless record.tag_id.class == "Array"
#      binding.pry
      record.errors[:tag_id] << "ERROR ERROR ERROR ERROR ERROR"
    end
  end
end