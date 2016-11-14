require 'rails_helper'

RSpec.feature "Updating Notifications" do 
  before do
    @foo = FactoryGirl.create(:user)
    @bar = FactoryGirl.create(:user)
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
      ])
    Notification.create(user: @foo, notified_by_user: @bar, notification_category_id: 5, read: false)
    login_as(@foo, :scope => :user)
  end
  
  scenario "User can mark notifications as read", js: true do
    visit(dashboard_path(@foo))
    click_link "Notifications"
    
    #followings notifications
    expect(page).to have_content("UNREAD")
    click_link "Mark as read"
    
    expect(page).not_to have_content("Mark as read")
    expect(page).not_to have_css("div.unread")
  end
  
  scenario "User can mark all notifications as read" do
    visit(dashboard_path(@foo))
    click_link "Notifications"
    
    #followings notifications
    expect(page).to have_content("UNREAD")
    click_link "Mark all as read"
    
    expect(page).not_to have_link("Mark as read")
    expect(page).not_to have_content("UNREAD")
  end
end