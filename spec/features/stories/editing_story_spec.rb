require 'rails_helper'
require 'support/macros'

RSpec.feature "Editing Stories" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @user = FactoryGirl.create(:user_with_published_stories)
    @user2 = FactoryGirl.create(:user_with_unpublished_stories)
    @story = Story.where(author_id: @user.id).active.first
    @story2 = Story.where(author_id: @user2.id).active.first
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
      {  tag_category_id: 1 , name: 'family' },
      {  tag_category_id: 1 , name: 'parents' },
      {  tag_category_id: 5 , name: 'brother' },
      {  tag_category_id: 5 , name: 'mother' },
      {  tag_category_id: 2 , name: 'anniversary' },
      {  tag_category_id: 2 , name: 'birthday' },
      {  tag_category_id: 6 , name: 'fail' }
      ])
    @fail_tag = Tag.where(name: "fail").first
    @birthday_tag = Tag.where(name: "birthday").first
    @story.update(fail: true)
    FactoryGirl.create(:classification, story_id: @story.id, tag_id: @fail_tag.id)
    FactoryGirl.create(:classification, story_id: @story.id, tag_id: @birthday_tag.id)
  end
  
  scenario "A user edits a published story", js: true do
    login_as(@user, :scope => :user)
    visit "/"
    
    click_link @story.final_title
    click_link "Edit Story"
    
    fill_in "Title", with: @updated_title
#    fill_in "Body", with: @updated_body
    fill_in_trix_editor('story_updated_body_trix_input_story_'+@story.id.to_s, @updated_body)
    uncheck("story_fail")
    click_button "Update Story"
    
    expect(page).to have_content(@updated_title)
    expect(page).to have_content(@updated_body)
    expect(page).to have_content("Story has been updated")
    within(".story_tags") do
      expect(page).not_to have_content("fail")
    end
    expect(page.current_path).to eq(story_path(Story.find(@story.id).slug))   
  end
  
  scenario "A user edits an unpublished story", js: true do
    login_as(@user2, :scope => :user)
    visit(dashboard_path(@user2))
    
    click_link @story2.raw_title
    click_link "Edit Story"
    
    fill_in "Title", with: @updated_title2
#    fill_in "Body", with: @updated_body
    fill_in_trix_editor('story_raw_body_trix_input_story_'+@story2.id.to_s, @updated_body2)
    check("story_fail")
    click_button "Contribute Story"
    
    expect(page).to have_content("Story has been updated")
    expect(page).to have_content(@updated_title2)
    expect(page).to have_content(@updated_body2)
    expect(page.current_path).to eq(story_path(Story.find(@story2.id).slug))   
    expect(Story.find(@story2.id).fail).to eq true
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