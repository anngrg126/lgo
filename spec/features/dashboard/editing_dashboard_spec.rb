require 'rails_helper'

RSpec.feature "Editing Dashboard" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @new_about_me = Faker::Hipster::sentence
  end
  
  scenario "Logged-in user can edit her basic profile information via the dashboard", js: true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    
    link = "a[href*='user_about_me']"
    find(link).click
    fill_in "user_about_me", with: @new_about_me
    click_button "Update"
    expect(page).to have_content(@new_about_me)
    
#    click_link "Upload Photo"
#    attach_file('user_image', './spec/fixtures/image.png')
    within '.user-profile' do
      find("a[href*='user_image']").click
    end
    expect(page).to have_css("input.image-input")
    execute_script("$('input[name=\"user[image]\"]').removeClass('image-input')")
    attach_file('user[image]', './spec/fixtures/image.png')
    click_button "Update"
    
    expect(page).to have_content("Profile has been updated")
    expect(page).to have_css("img[src*='image.png']")
  end
  
  scenario "Logged-in user fails to edit her basic profile information via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    
#    click_link "Upload Photo"
    within '.user-profile' do
      find("a[href*='user_image']").click
    end
    expect(page).to have_css("input.image-input")
    execute_script("$('input[name=\"user[image]\"]').removeClass('image-input')")
    attach_file('user_image', './spec/fixtures/text.rtf')
    click_button "Update"
    expect(page).to have_content("Image is invalid")
    
  end
  
  scenario "Logged-in user fails to edit another user's dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user2))
    
    expect(page).not_to have_link("Edit")
    expect(page).not_to have_link("Upload Photo")
  end
end