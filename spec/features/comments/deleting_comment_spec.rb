require "rails_helper"

RSpec.feature "Deleting Comments" do
  before do
    @bar = FactoryGirl.create(:user_with_published_stories)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story_foo = Story.where(author_id: @foo.id).active.first
    @story_bar = Story.where(author_id: @bar.id).active.first
    
    @comment1 = Comment.create(body: Faker::Hipster::word, user: @foo, story: @story_foo)
    @comment2 = Comment.create(body: Faker::Hipster::sentence, user: @bar, story: @story_foo)
    @comment3 = Comment.create(body: Faker::Hipster::paragraph, user: @bar, story: @story_bar)
  end
  
  scenario "An owner succeeds " do
    login_as(@foo, :scope => :user)
    
    visit "/"
    click_link @story_foo.final_title  
    
    page.click_link('', :href => story_comment_path(@story_foo, @comment1))
    
    expect(page).to have_content("Comment has been deleted")
    expect(page).not_to have_content(@comment1)
  end
  
  scenario "A non-owner fails" do
    login_as(@foo, :scope => :user)

    visit "/"
    click_link @story_bar.final_title
    
    expect(page).not_to have_link('', :href => story_comment_path(@story_foo, @comment1))
    
  end
end