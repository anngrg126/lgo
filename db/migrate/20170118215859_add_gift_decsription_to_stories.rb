class AddGiftDecsriptionToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :raw_gift_description, :string
    add_column :stories, :updated_gift_description, :string
    add_column :stories, :final_gift_description, :string
  end
end
