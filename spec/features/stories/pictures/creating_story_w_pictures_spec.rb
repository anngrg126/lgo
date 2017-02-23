require 'rails_helper'
require 'support/macros'

RSpec.feature "Creating Stories with Pictures", :type => :feature do 
  
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
    visit "/stories/new"
    @title = Faker::Hipster::sentence
    fill_in "Give your story a title", with: @title
    fill_in_trix_editor('story_raw_body_trix_input_story', Faker::Hipster::paragraph)
  end
  
  scenario "A user creates a new story w/ one picture" do
    attach_file('image[]', './spec/fixtures/image.png')
    click_button "Share Story"
    
    expect(page).to have_content("Story has been submitted")
    expect(page.current_path).to eq(dashboard_path(@user))
    
    click_link @title
    expect(page).to have_css("img[src*='image.png']")
  end
  
  scenario "A user creates a new story w/ many pictures", js: true do
    attach_file('image[]', './spec/fixtures/image.png')
    
    click_link "Add another image"
    within('.nested-fields') do
      attach_file('image[]', './spec/fixtures/image.png')
    end
    click_button "Share Story"
    
    expect(page).to have_content("Story has been submitted")
    expect(page.current_path).to eq(dashboard_path(@user))
    
    click_link @title
    expect(page).to have_css("img[src*='image.png']", count: 2)
  end
  
  scenario "Logged-in user fails to add pictures to a story", js: true do
    attach_file('image[]', './spec/fixtures/text.rtf')
    click_button "Share Story"
    
    expect(page).to have_content("Image content type is invalid")
  end
end
