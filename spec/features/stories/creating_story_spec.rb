require 'rails_helper'
require 'support/macros'

RSpec.feature "Creating Stories", :type => :feature do 
  
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end
  
  scenario "A user creates a new story" do
    visit "/"
    within(".index_story_share") do
      click_link "Share a Story"
    end
    fill_in "Give your story a title", with: Faker::Hipster::sentence
    fill_in_trix_editor('story_raw_body_trix_input_story', Faker::Hipster::paragraph)
    fill_in "In 10 words or less, what was the gift?", with: Faker::Hipster::sentence
    check "story_anonymous"
    choose "story_review_true"
    check "story_fail"
    
    click_button "Share Story"    

    expect(page).to have_content("Thanks for sharing a story")
#    expect(page.current_path).to eq(stories_path)
    expect(page.current_path).to eq(dashboard_path(@user))
  end
  
  scenario "A user fails to create a new story", :js => true do
    visit "/"
    within(".index_story_share") do
      click_link "Share a Story"
    end
    
    fill_in "Give your story a title", with: ""
    fill_in_trix_editor('story_raw_body_trix_input_story', "")
    fill_in "In 10 words or less, what was the gift?", with: ""
    click_button "Share Story"
    assert_text("Body can't be blank")
    
    expect(page).to have_content("Story has not been submitted")
    expect(page).to have_content("Body can't be blank")
    expect(page).not_to have_content("Title can't be blank")
    expect(page).not_to have_content("Gift description can't be blank")
  end
end

