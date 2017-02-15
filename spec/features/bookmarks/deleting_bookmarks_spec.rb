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
    
    within "#bookmark_buttons_1" do
      expect(page).to have_css('span[class="fa fa-bookmark fa-lg"]')
      expect(page).to have_link('', :href => story_bookmark_path(@story_bar, @foo.id))
      page.click_link('', :href => story_bookmark_path(@story_bar, @foo.id))
      expect(page).to have_css('span[class="fa fa-bookmark-o fa-lg"]')
    end

    expect(page.current_path).to eq(story_path(@story_bar))
    
    # expect(Bookmark.where(story_id: @story_bar.id).count).to eq(0)
  end
end