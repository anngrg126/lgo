class Following < ApplicationRecord
  belongs_to :user
  belongs_to :follower, class_name: "User"
  
  scope :follower_active, -> { joins(:follower).where(users: {deactivated_at: nil}) }
  scope :following_active, -> { joins(:user).where(users: {deactivated_at: nil}) }
end