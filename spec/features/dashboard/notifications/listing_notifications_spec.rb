require 'rails_helper'

RSpec.feature "Listing Notifications" do 
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
  
  scenario "Shows list of user's notifications", js: true do
    visit "/"
    click_link "Notifications"
    
    #Note: notifications re: published stories are in spec/features/admin/stories/editing_story_spec.rb
    
    #Note: should implement test that all story poster followers receive notification when story is published
    
    #Note: notifications re: commenting on stories are in spec/features/comments/creating_comments_spec.rb
    
    #Note: should implement test that all others who commented on a story also receive a notification
    
    #Note: notifications re: bookmarking stories are in spec/features/creating_bookmarks_spec.rb
    
    #Note: notifications re: reacting to stories are in spec/features/creating_reaction_spec.rb
    
    #followings notifications
    expect(page).to have_content("#{@bar.full_name} followed you")
    expect(page).to have_link(@bar.full_name)
  end
end