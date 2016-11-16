require 'rails_helper'
require 'support/macros'

RSpec.feature "Updating Stories with Pictures", :type => :feature do 
  before do
    @user = FactoryGirl.create(:user_with_unpublished_stories)
    login_as(@user, :scope => :user)
    visit(story_path(Story.find_by(author_id: @user.id)))
  end
  
  scenario "Logged-in user can add one picture to a story after creating" do
#    expect(page).not_to have_content("Delete Picture")
    click_link "Upload More Pictures"
    attach_file('image[]', './spec/fixtures/image.png')
    
    click_button "Create Picture"
    
    expect(page).to have_css("img[src*='image.png']", count: 2 )
    expect(page).to have_content("Delete Picture")
  end
  
  scenario "Logged-in user can delete pictures from story after creating" do
    click_link "Delete Picture"
    expect(page).not_to have_css("img[src*='image.png']")
    expect(page).not_to have_content("Delete Picture")
  end
  
  
  scenario "Logged-in user can add multiple pictures to a story after creating", js: true do
    click_link "Upload More Pictures"
    attach_file('image[]', './spec/fixtures/image.png')
    
    click_link "Add another image"
    within('#new_picture > div > .upload_image') do
      attach_file('image[]', './spec/fixtures/image.png')
    end
    click_button "Create Picture"
    
    # cnt_images = Picture.where(story_id: @story.id).count
    cnt_images=3
    
    expect(page).to have_css("img[src*='image.png']", :count => cnt_images)
    expect(page).to have_content("Delete Picture", :count => cnt_images)
  end
  
  scenario "Logged-in user fails to add pictures to a story after creating", js: true do
    click_link "Upload More Pictures"
    click_button "Create Picture"
    
    expect(page).to have_content("Image can't be blank")
  end
  
end