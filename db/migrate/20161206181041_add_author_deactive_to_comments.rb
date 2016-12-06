class AddAuthorDeactiveToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :author_deactive, :boolean
  end
end
