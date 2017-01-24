class CreateUserSessionLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :user_session_logs do |t|
      t.integer  "user_id",    null: false
      t.string   "user_ip"
      t.datetime  "sign_in"
      t.datetime  "sign_out"
    end
  end
end
