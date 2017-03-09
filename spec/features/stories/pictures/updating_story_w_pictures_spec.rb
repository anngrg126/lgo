require 'rails_helper'
require 'support/macros'

RSpec.feature "Updating Stories with Pictures", :type => :feature do 
  before do
    @user = FactoryGirl.create(:user_with_unpublished_stories)
    login_as(@user, :scope => :user)
    @story = Story.where(author_id: @user.id).active.first
    visit(story_path(@story))
    @picture = @story.pictures.first
  end
  
  scenario "Logged-in user can add one picture to a story after creating" do
#    expect(page).not_to have_content("Delete Picture")
    within (".upload-pictures") do
      click_link "Upload more pictures"
    end
    attach_file('image[]', './spec/fixtures/image.png')
    
    click_button "Create Picture"
    
    within (".story-pictures") do
      expect(page).to have_css("img[src*='image.png']", count: 2 )
      expect(page).to have_css('a[data-method="delete"]', :count => 2)
    end
  end
  
  scenario "Logged-in user can delete pictures from story after creating" do
    within (".story-pictures") do
#      click_link "Delete Picture"
      expect(page).to have_css(".fa-trash-o", :count => 1)
      first('a.minor-link').click
#      expect(page).not_to have_css("img[src*='image.png']")
#      expect(page).not_to have_css(".fa-trash-o")
    end
  end
  
  scenario "Logged-in user can add multiple pictures to a story after creating", js: true do
    within (".upload-pictures") do
      click_link "Upload more pictures"
    end
    execute_script("$('input[name=\"image[]\"]').removeClass('image-input')")
    attach_file('image[]', './spec/fixtures/image.png')
    
    click_link "Add another image"
    expect(page).to have_css(".fa-camera", count: 5)
     within('.nested-fields') do
      execute_script("$('input[name=\"image[]\"]').removeClass('image-input')")
      attach_file('image[]', './spec/fixtures/image.png')
    end
  
#    within('#new_picture > div > .upload_image:nth-child(3)') do
#      attach_file('image[]', './spec/fixtures/image.png')
#    end
#    click_button "Create Picture"
    
    # cnt_images = Picture.where(story_id: @story.id).count
    cnt_images=3
    within (".story-pictures") do
      expect(page).to have_css("img[src*='image.png']", :count => cnt_images)
      expect(page).to have_css('a[data-method="delete"]', :count => cnt_images)
    end
  end
  
  scenario "Logged-in user fails to add pictures to a story after creating", js: true do
    within (".upload-pictures") do
      click_link "Upload more pictures"
    end
    click_button "Create Picture"
    expect(page).to have_content("Picture has not been uploaded.")
#    expect(page).to have_content("Image can't be blank")
  end
  
end