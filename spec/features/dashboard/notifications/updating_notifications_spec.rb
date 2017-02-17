require 'rails_helper'

RSpec.feature "Updating Notifications" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @foo = FactoryGirl.create(:user)
    @bar = FactoryGirl.create(:user)
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
      ])
    @notification1 = Notification.create(user: @foo, notified_by_user: @bar, notification_category_id: 5, read: false)
    login_as(@foo, :scope => :user)
  end
  
  scenario "User can mark notifications as read", js: true do
    visit "/"
    click_link "My Notifications (1)"
    
    expect(page).to have_link("Mark all as read")
    #followings notifications
    within("#noti_id_#{@notification1.id}") do
      expect(page).to have_link("Mark as read")
      page.click_link("Mark as read")
      expect(page).not_to have_link("Mark as read")
      expect(page).to have_content("Read")
    end
  end
  
  scenario "User can mark all notifications as read" do
    visit "/"
    click_link "My Notifications (1)"
    
    #followings notifications
    # expect(page).to have_content("UNREAD")
    click_link "Mark all as read"
    
    expect(page).not_to have_link("Mark as read")
    # expect(page).not_to have_content("UNREAD")
  end
end