require 'rails_helper'

RSpec.feature "Editing Account Settings" do 
  before do
    @user = FactoryGirl.create(:user)
    @new_password = Faker::Internet.password
    @new_email = Faker::Internet.email
  end
  
  scenario "Logged-in user edits her password via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    click_link "Settings"
    
    click_link("Change Password")
    fill_in "Password", with: @new_password
    fill_in "Confirm new password", with: @new_password
    fill_in "Current password", with: @user.password
    click_button "Update"
    expect(page).to have_content("Profile has been updated")
  end
  
  scenario "Logged-in user fails to edit her password via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    click_link "Settings"
    
    click_link("Change Password")
    fill_in "Current password", with: @new_password
    click_button "Update"
    expect(page).to have_content("Current password is invalid")
  end
  
  scenario "Logged-in user edits her email via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    click_link "Settings"
    
    click_link("Change Email")
    fill_in "Email", with: @new_email
    fill_in "Current password", with: @user.password
    click_button "Update"
    expect(page).to have_content("Profile has been updated")
    expect(page).to have_content @new_email
  end
  
  scenario "Logged-in user fails to edit her email via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    click_link "Settings"
    
    click_link("Change Email")
    fill_in "Email", with: ""
    fill_in "Current password", with: @user.password
    click_button "Update"
    expect(page).to have_content("Profile has not been updated")
    expect(page).to have_content("Email can't be blank")
  end
  
  scenario "Logged-in user edits her gender via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    click_link "Settings"
    
    link = "a[href*='user_gender']"
    find(link).click
    choose('user_gender_male')
    click_button "Update"
    expect(page).to have_content("Profile has been updated")
  end
end