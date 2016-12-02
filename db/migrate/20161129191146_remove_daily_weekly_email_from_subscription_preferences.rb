class RemoveDailyWeeklyEmailFromSubscriptionPreferences < ActiveRecord::Migration[5.0]
  def change
    remove_column :subscription_preferences, :daily_email, :boolean
    remove_column :subscription_preferences, :weekly_email, :boolean
  end
end
