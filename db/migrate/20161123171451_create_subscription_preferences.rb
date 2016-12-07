class CreateSubscriptionPreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :subscription_preferences do |t|
      t.references :user, foreign_key: true
      t.boolean :daily_email, default: true
      t.boolean :weekly_email

      t.timestamps
    end
  end
end
