class CreateReactions < ActiveRecord::Migration[5.0]
  def change
    create_table :reactions do |t|
      t.references :story, foreign_key: true
      t.references :reaction_category, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
