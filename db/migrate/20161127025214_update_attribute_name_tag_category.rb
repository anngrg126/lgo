class UpdateAttributeNameTagCategory < ActiveRecord::Migration[5.0]
  def change
    remove_column :tag_categories, :name
    add_column :tag_categories, :category, :string
  end
end
