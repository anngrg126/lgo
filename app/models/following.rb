class Following < ApplicationRecord
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_id'
  
  scope :follower_active, -> { joins(:follower).where(users: {deactivated_at: nil}) }
  scope :following_active, -> { joins(:user).where(users: {deactivated_at: nil}) }
end