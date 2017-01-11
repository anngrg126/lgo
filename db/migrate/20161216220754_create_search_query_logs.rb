class CreateSearchQueryLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :search_query_logs do |t|
      t.string :query_string
      t.integer :result_count
      t.string :search_param
      t.integer :user_id
      t.timestamps
    end
  end
end