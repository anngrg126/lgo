class AddDescriptionToClassification < ActiveRecord::Migration[5.0]
  def change
    add_column :classifications, :description, :string
  end
end
