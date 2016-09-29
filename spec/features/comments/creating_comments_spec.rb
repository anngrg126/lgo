require "rails_helper"

RSpec.feature "Adding Comments to Stories" do
  before do
    @bar = FactoryGirl.create(:user)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story = Story.find_by(author_id: @foo.id)
    @comment1 = Faker::Hipster::sentence
  end
  
  scenario "Permit a signed in user to write a comment" do
    login_as(@bar, :scope => :user)
    
    visit "/"
    click_link @story.final_title
    fill_in "New Comment", with: @comment1
    click_button "Add Comment"
    
    expect(page).to have_content("Comment has been added")
    expect(page).to have_content(@comment1)
    expect(page.current_path).to eq(story_path(@story))
  end
  
  scenario "A user fails to create a new comment", :js => true do
    login_as(@bar, :scope => :user)
    
    visit "/"
    click_link @story.final_title
    fill_in "New Comment", with: ""
    click_button "Add Comment"
    assert_text("Body can't be blank")
    
    expect(page).to have_content("Comment has not been added")
    expect(page).to have_content("Body can't be blank")
    
  end
  
end
  