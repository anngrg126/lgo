require "rails_helper"

RSpec.feature "Editing Comments" do
  before do
    @bar = FactoryGirl.create(:user_with_published_stories)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story_foo = Story.find_by(author_id: @foo.id)
    @story_bar = Story.find_by(author_id: @bar.id)
    
    @comment1 = Comment.create(body: Faker::Hipster::sentence, user: @foo, story: @story_foo)
    @comment2 = Comment.create(body: Faker::Hipster::sentence, user: @bar, story: @story_foo)
    @comment3 = Comment.create(body: Faker::Hipster::paragraph, user: @bar, story: @story_bar)
  end
  
  scenario "An owner succeeds", :js => true do
    login_as(@foo, :scope => :user)
    
    visit "/"
    click_link @story_foo.final_title
    
    link = "a[href='/stories/#{@story_foo.slug}/comments/#{@comment1.id}/edit']"
    find(link).click
    expect(page).to have_field('Edit Comment', :with => @comment1.body)
    within("#edit_comment_#{@comment1.id}"){fill_in("Edit Comment", with: "OK read" )}
    click_button "Update Comment"
    
    expect(page).to have_content("OK read")
    expect(page).not_to have_content(@comment1.body)
  end
  
  scenario "A non-owner fails" do
    login_as(@foo, :scope => :user)
    
    visit "/"
    click_link @story_bar.final_title
    
    expect(page).not_to have_content("Edit")
    
  end
end