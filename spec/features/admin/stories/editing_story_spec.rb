require 'rails_helper'
require 'support/macros'

RSpec.feature "Editing Stories" do 
  before do
    @user = FactoryGirl.create(:user_with_unpublished_stories)
    @user2 = FactoryGirl.create(:user_with_unpublished_updated_stories)
    @admin = FactoryGirl.create(:admin)
    @story = Story.find_by(author_id: @user.id)
    @story2 = Story.find_by(author_id: @user2.id)
    @final_title1 = Faker::Hipster::sentence
    @final_body1 = Faker::Hipster::paragraph
    @final_title2 = Faker::Hipster::sentence
    @final_body2 = Faker::Hipster::paragraph
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
      ])
  end
  
  scenario "An admin edits a story", js: true do
    login_as(@admin, :scope => :user)
    visit "/admin"
    
    click_link @story.raw_title
    click_link "Edit Story"
    
    expect(page).to have_content("#{@story.user(:author_id).full_name}")
    expect(page).to have_content(@story.created_at.strftime("%b %d, %Y"))
    expect(page).to have_content("Not Anonymous")
    expect(page).to have_content(@story.raw_title)
    expect(page).to have_content(@story.raw_body)
    expect(page).to have_content("User requested a GiftOn editor to add a light touch? No")
    
    attach_file('story_main_image', './spec/fixtures/mainimage.png')
    fill_in "Final Title", with: @final_title1
#    fill_in "Final Body", with: @final_body1
    fill_in_trix_editor('story_final_body_trix_input_story_'+@story.id.to_s, @final_body1)
#    check 'Published'
    click_button "Update Story"
    
    expect(page).to have_content("Story has been updated")
    expect(page.current_path).to eq(admin_story_path(@story))  
    expect(page).to have_content(@story.final_title)
    expect(page).to have_content(@story.final_body)
    expect(page).to have_content("Admin: #{@admin.full_name}")
    expect(page).to have_css("img[src*='mainimage.png']")
    
    logout(:user)
    
    login_as(@user, :scope => :user)
    visit "/"
    click_link "Notifications"
    expect(page).to have_content("Your story has been published! See it here: ")
    expect(page).to have_link(@story.final_title)
  end
  
  scenario "An admin edits an updated story", js: true do
    login_as(@admin, :scope => :user)
    visit "/admin"
    
    click_link @story2.raw_title
    click_link "Edit Story"
    
    expect(page).to have_content(@story2.updated_title)
    expect(page).to have_content(@story2.updated_body)
    
    fill_in "Final Title", with: @final_title2
#    fill_in "Final Body", with: @final_body2
    fill_in_trix_editor('story_final_body_trix_input_story_'+@story2.id.to_s, @final_body2)
    click_button "Update Story"
    
    expect(page).to have_content("Story has been updated")
    expect(page.current_path).to eq(admin_story_path(@story2))  
    expect(page).to have_content(@final_title2)
    expect(page).to have_content(@final_body2)
    expect(page).to have_content("Published")
  end
  
  scenario "An admin fails to edit a story", js: true do
    login_as(@admin, :scope => :user)
    visit "/admin"
    
    click_link @story.raw_title
    click_link "Edit Story"
    
    fill_in "Final Title", with: ""
    fill_in_trix_editor('story_final_body_trix_input_story_'+@story.id.to_s, "")
    click_button "Update Story"
    
    expect(page).to have_content("Story has not been updated")
    expect(page).to have_content("Main image can't be blank")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Body can't be blank")
  end
end