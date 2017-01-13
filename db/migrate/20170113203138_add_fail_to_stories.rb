class AddFailToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :fail, :boolean
  end
end
