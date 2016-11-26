class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.references :tag_category, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
