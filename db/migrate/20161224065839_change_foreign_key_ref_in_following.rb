class ChangeForeignKeyRefInFollowing < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :followings, :users, column: :follower_id
  end
end
