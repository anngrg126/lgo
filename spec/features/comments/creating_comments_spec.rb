require "rails_helper"

RSpec.feature "Adding Comments to Stories" do
  before do
    @bar = FactoryGirl.create(:user)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story = Story.where(author_id: @foo.id).active.first
    @comment1 = Faker::Hipster::sentence
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
      ])
  end
  
  scenario "Permit a signed in user to write a comment", js: true do
    login_as(@bar, :scope => :user)
    
    visit "/"
    click_link @story.final_title
    fill_in "New Comment", with: @comment1
    click_button "Add Comment"
    
    expect(page).to have_content("Comment has been added")
    expect(page).to have_content(@comment1)
    expect(page.current_path).to eq(story_path(@story))
    
    logout(:user)
    
    login_as(@foo, :scope => :user)
    visit "/"
    click_link "Notifications"
    
    expect(page).to have_content("#{@bar.full_name} commented on your story #{@story.final_title}")
    expect(page).to have_link(@story.final_title)
    expect(page).to have_link(@bar.full_name)
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
  