require "rails_helper"

RSpec.feature "Adding Saves to Stories" do
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
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
  
    within "#bookmark_buttons_1" do
      expect(page).to have_css('span[class="fa fa-bookmark-o fa-lg"]')
      expect(page).to have_link('', :href => story_bookmarks_path(story_id: @story.id, user_id: @bar.id))
      page.click_link('', :href => story_bookmarks_path(story_id: @story.id, user_id: @bar.id))
      expect(page).to have_css('span[class="fa fa-bookmark fa-lg"]')
    end

    expect(page.current_path).to eq(story_path(@story))
    
    expect(Bookmark.where(user_id: @bar.id).count).to eq(1)

    logout(:user)
    
    login_as(@foo, :scope => :user)
    visit "/"
    click_link "Notifications"
    
    expect(page).to have_content("Woohoo! Someone bookmarked your story #{@story.final_title}")
    expect(page).to have_link(@story.final_title)
  end
  
  scenario "A non-signed in user fails to save a story" do
    visit "/"
    click_link @story.final_title
    
    within "#bookmark_buttons_1" do
      expect(page).to have_css('span[class="fa fa-bookmark-o fa-lg"]')
      expect(page).to have_link('', :href => story_bookmarks_path(story_id: @story.id, user_id: 0))
      page.click_link('', :href => story_bookmarks_path(story_id: @story.id, user_id: 0))
    end
    
    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page.current_path).to eq(new_user_session_path)
  end
end