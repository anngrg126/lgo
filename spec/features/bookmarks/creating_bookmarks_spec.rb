require "rails_helper"

RSpec.feature "Adding Saves to Stories" do
  before do
    @bar = FactoryGirl.create(:user)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story = Story.where(author_id: @foo.id).active.first
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
      ])
  end
  
  scenario "Permit a signed in user to save a story", :js => true do
    login_as(@bar, :scope => :user)
    visit "/"
    click_link @story.final_title
  
    click_button "Save Story"
    
    expect(page).to have_content("Story has been saved")
    expect(page).to have_content("Saves: 1")
    expect(page.current_path).to eq(story_path(@story))
    
    logout(:user)
    
    login_as(@foo, :scope => :user)
    visit "/"
    click_link "Notifications"
    expect(page).to have_content("Woohoo! Someone bookmarked your story #{@story.final_title}")
    expect(page).to have_link(@story.final_title)
  end
  
  scenario "A non-signed in user fails to save a story", :js => true do
    visit "/"
    click_link @story.final_title
    
    click_button "Save Story"
    
    expect(page).to have_content("Please sign in to continue")
    expect(page.current_path).to eq(new_user_session_path)
  end
end