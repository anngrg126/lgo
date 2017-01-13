require 'rails_helper'
require 'support/macros'

RSpec.feature "Editing Stories" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @user = FactoryGirl.create(:user_with_unpublished_stories)
    @user2 = FactoryGirl.create(:user_with_unpublished_updated_stories)
    @admin = FactoryGirl.create(:admin)
    @story = Story.where(author_id: @user.id).active.first
    @story.update(fail: true)
    @story2 = Story.where(author_id: @user2.id).active.first
    @final_title1 = Faker::Hipster::sentence(4)
    @final_body1 = Faker::Hipster::paragraph
    @final_title2 = Faker::Hipster::sentence(4)
    @final_body2 = Faker::Hipster::paragraph
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
      ])
    TagCategory.create([
      {id: 1, category: "Relationship"},
      {id: 2, category: "Occasion"},
      {id: 3, category: "Type"},
      {id: 4, category: "Interests"},
      {id: 5, category: "To_recipient"},
      {id: 6, category: "Gifton_reaction"},
      {id: 7, category: "Collection"}
      ])
    Tag.create([
      {  id: 1, tag_category_id: 1 , name: 'family' },
      {  id: 2, tag_category_id: 1 , name: 'parents' },
      {  id: 3, tag_category_id: 5 , name: 'brother' },
      {  id: 4, tag_category_id: 5 , name: 'mother' },
      {  id: 5, tag_category_id: 2 , name: 'anniversary' },
      {  id: 6, tag_category_id: 2 , name: 'birthday' }
      ])
  end
  
  scenario "An admin edits a story", js: true do
    login_as(@admin, :scope => :user)
    visit "/admin"
    
    click_link @story.raw_title
    click_link "Edit Story"
    
    expect(page).to have_content("#{User.find(@story.author_id).full_name}")
    expect(page).to have_content(@story.created_at.strftime("%b %d, %Y"))
    expect(page).to have_content("Not Anonymous")
    expect(page).to have_content(@story.raw_title)
    expect(page).to have_content(@story.raw_body)
    expect(page).to have_content("User requested a GiftOn editor to add a light touch? No")
    expect(page).to have_content("Story Fail")
    
    attach_file('story_main_image', './spec/fixtures/mainimage.png')
    fill_in "Final Title", with: @final_title1
#    fill_in "Final Body", with: @final_body1
    fill_in_trix_editor('story_final_body_trix_input_story_'+@story.id.to_s, @final_body1)
#    check 'Published'
    find("input[type='checkbox'][id*='1']").set(true) #family
    find("input[type='checkbox'][id*='3']").set(true) #brother
    find("input[id*=primary][value='3']").set(true) #brother-primary
    find("input[type='checkbox'][id*='6']").set(true) #birthday
    find("input[id*=primary][value='6']").set(true) #birthday-primary
    uncheck("story_fail")
    
    click_button "Update Story"
    
    expect(page).to have_content("Story has been updated")
    expect(page.current_path).to eq(admin_story_path(Story.find(@story.id).slug))  
    expect(page).to have_content(@story.final_title)
    expect(page).to have_content(@story.final_body)
    expect(page).to have_content("Admin: #{@admin.full_name}")
    expect(page).to have_css("img[src*='mainimage.png']")
    expect(page).to have_content("brother (primary)")
    expect(page).to have_content("family")
    expect(page).to have_content("birthday (primary)")
    expect(page).not_to have_content("Story Fail")
    
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
    find("input[type='checkbox'][id*='1']").set(true) #family
    find("input[type='checkbox'][id*='3']").set(true) #brother
    find("input[id*=primary][value='3']").set(true) #brother-primary
    find("input[type='checkbox'][id*='6']").set(true) #birthday
    find("input[id*=primary][value='6']").set(true) #birthday-primary
    click_button "Update Story"
    
    expect(page).to have_content("Story has been updated")
    expect(page.current_path).to eq(admin_story_path(Story.find(@story2.id).slug))  
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
    find("input[id*=primary][value='3']").set(true)
    find("input[id*=primary][value='6']").set(true)
    
    click_button "Update Story"
    
    expect(page).to have_content("Story has not been updated")
    expect(page).to have_content("Main image can't be blank")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Body can't be blank")
    expect(page).to have_content("You need tags.")
  end
end