class CreateClassifications < ActiveRecord::Migration[5.0]
  def change
    create_table :classifications do |t|
      t.references :tag, foreign_key: true
      t.references :story, foreign_key: true

      t.timestamps
    end
  end
end
