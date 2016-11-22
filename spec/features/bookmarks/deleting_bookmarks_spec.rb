require "rails_helper"

RSpec.feature "Deleting Bookmarks" do
  before do
    @bar = FactoryGirl.create(:user_with_published_stories)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story_foo = Story.where(author_id: @foo.id).active.first
    @story_bar = Story.where(author_id: @bar.id).active.first
    @bookmark = Bookmark.create(user: @foo, story: @story_bar)
  end
  
  scenario "A user succeeds", :js => true do
    login_as(@foo, :scope => :user)
    
    visit "/"
    click_link @story_bar.final_title  
    click_link "Unsave Story"
    
    expect(page).to have_content("Story save has been deleted")
    expect(page).to have_content("Saves: 0")
    expect(page).to have_button("Save Story")
    expect(page).not_to have_link("Unsave Story")
  end
end