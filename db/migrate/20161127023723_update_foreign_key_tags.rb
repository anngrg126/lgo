class UpdateForeignKeyTags < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :tags, :tag_categories
    
    add_foreign_key :tags, :tag_categories, on_delete: :cascade
    
  end
end
