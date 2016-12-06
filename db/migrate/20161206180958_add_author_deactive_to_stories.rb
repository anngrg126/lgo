class AddAuthorDeactiveToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :author_deactive, :boolean
  end
end
