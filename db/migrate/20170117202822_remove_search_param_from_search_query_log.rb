class RemoveSearchParamFromSearchQueryLog < ActiveRecord::Migration[5.0]
  def change
    remove_column :search_query_logs, :search_param, :string
  end
end
