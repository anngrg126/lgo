require 'rails_helper'

RSpec.feature "Editing Dashboard" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @new_first_name = Faker::Name::first_name
    @new_last_name = Faker::Name::last_name
    @new_about_me = Faker::Hipster::sentence
  end
  
  scenario "Logged-in user can edit her basic profile information via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    
    link = "a[href*='user_name']"
    find(link).click
    fill_in "First Name", with: @new_first_name
    fill_in "Last Name", with: @new_last_name
    click_button "Update"
    have_content(@new_first_name.titleize.gsub(/\b\w/) { |w| w.upcase })
    expect(page).to have_content(@new_last_name.titleize.gsub(/\b\w/) { |w| w.upcase })
    
    link = "a[href*='user_about_me']"
    find(link).click
    fill_in "user_about_me", with: @new_about_me
    click_button "Update"
    expect(page).to have_content(@new_about_me)
    
    click_link "Upload Photo"
    attach_file('user_image', './spec/fixtures/image.png')
    click_button "Update"
    
    expect(page).to have_content("Profile has been updated")
    expect(page).to have_css("img[src*='image.png']")
  end
  
  scenario "Logged-in user fails to edit her basic profile information via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    link = "a[href*='user_name']"
    find(link).click
    fill_in "First Name", with: ""
    fill_in "Last Name", with: ""
    click_button "Update"
    
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    
    click_button "Cancel"
    
    visit(dashboard_path(@user))
    click_link "Upload Photo"
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