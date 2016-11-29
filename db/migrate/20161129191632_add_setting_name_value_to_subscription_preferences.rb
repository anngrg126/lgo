class AddSettingNameValueToSubscriptionPreferences < ActiveRecord::Migration[5.0]
  def change
    add_column :subscription_preferences, :setting_name, :string
    add_column :subscription_preferences, :setting_value, :boolean
  end
end
