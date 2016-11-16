require 'rails_helper'
require 'support/macros'

RSpec.feature "Editing Stories" do 
  before do
    @user = FactoryGirl.create(:user_with_published_stories)
    @user2 = FactoryGirl.create(:user_with_unpublished_stories)
    @story = Story.find_by(author_id: @user.id)
    @story2 = Story.find_by(author_id: @user2.id)
    @updated_title = Faker::Hipster::sentence
    @updated_title2 = Faker::Hipster::sentence
    @updated_body = Faker::Hipster::paragraph
    @updated_body2 = Faker::Hipster::paragraph
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
      ])
  end
  
  scenario "A user edits a published story", js: true do
    login_as(@user, :scope => :user)
    visit "/"
    
    click_link @story.final_title
    click_link "Edit Story"
    
    fill_in "Title", with: @updated_title
#    fill_in "Body", with: @updated_body
    fill_in_trix_editor('story_updated_body_trix_input_story_'+@story.id.to_s, @updated_body)
    click_button "Update Story"
    
    expect(page).to have_content("Story has been updated")
    expect(page).to have_content(@updated_title)
    expect(page).to have_content(@updated_body)
    expect(page.current_path).to eq(story_path(@story))   
  end
  
  scenario "A user edits an unpublished story", js: true do
    login_as(@user2, :scope => :user)
    visit(dashboard_path(@user2))
    
    click_link @story2.raw_title
    click_link "Edit Story"
    
    fill_in "Title", with: @updated_title2
#    fill_in "Body", with: @updated_body
    fill_in_trix_editor('story_raw_body_trix_input_story_'+@story2.id.to_s, @updated_body2)
    click_button "Contribute Story"
    
    expect(page).to have_content("Story has been updated")
    expect(page).to have_content(@updated_title2)
    expect(page).to have_content(@updated_body2)
    expect(page.current_path).to eq(story_path(@story2))   
  end
  
  scenario "A user fails to edit a story", js: true do
    login_as(@user, :scope => :user)
    visit "/"
    
    click_link @story.final_title
    click_link "Edit Story"
    
    fill_in "Title", with: ""
#    fill_in "Body", with: @updated_body
    fill_in_trix_editor('story_updated_body_trix_input_story_'+@story.id.to_s, "")
    click_button "Update Story"
    
    expect(page).to have_content("Story has not been updated")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Body can't be blank")
  end
end