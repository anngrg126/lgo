class AddDeletedAtToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :deleted_at, :datetime
  end
end
