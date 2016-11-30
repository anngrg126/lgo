class Comment < ApplicationRecord
  belongs_to :story
  belongs_to :user
  
  validates :body, presence: true
  
  scope :active, -> { where(deleted_at: nil) }
end
