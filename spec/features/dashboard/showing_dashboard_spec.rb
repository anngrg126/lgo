require 'rails_helper'

RSpec.feature "Showing Dashboard" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @user = FactoryGirl.create(:user_with_published_stories)
    @user2 = FactoryGirl.create(:user)
    @user2.update(about_me: "")
  end
  
  scenario "Logged-in user can see her basic profile information on the dashboard" do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    
    expect(page).to have_content(@user.full_name)
    expect(page).to have_content(@user.about_me)
    
    visit(dashboard_path(@user2))
    expect(page).not_to have_content("About Me")
  end
  
  scenario "Logged-in user with blank 'About Me' sees a call to action to update About Me" do
    login_as(@user2, :scope => :user)
    visit(dashboard_path(@user2))
    
    expect(page).to have_link("Introduce yourself here")
  end
  
  scenario "Non-logged-in user can go to other user's dashboards" do
    visit "/"
    
    click_link "#{@user.full_name}"
    expect(page).to have_current_path(dashboard_path(@user))
    expect(page).not_to have_link("Edit")
    expect(page).not_to have_link("Settings")
  end

end