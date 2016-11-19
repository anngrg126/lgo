class AddStoryIdToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :story_id, :integer
  end
end
