class ChangeAuthorDeactivatedInComments < ActiveRecord::Migration[5.0]
  def self.up
    change_column :comments, :author_deactive, :boolean, :default  => false
  end
 
  def self.down
    change_column :comments, :author_deactive, :boolean, :default  => false
  end
end
