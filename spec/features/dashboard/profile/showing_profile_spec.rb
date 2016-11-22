require 'rails_helper'

RSpec.feature "Showing Profile" do 
  before do
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @new_first_name = Faker::Name::first_name
    @new_last_name = Faker::Name::last_name
    @new_about_me = Faker::Hipster::sentence
  end
  
  scenario "Logged-in user can see her profile information via the dashboard", js:true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    click_link "Settings"
    
    expect(page).to have_content(@user.email)
    expect(page).to have_link("Change Email")
    expect(page).to have_link("Change Password")
    expect(page).to have_content(@user.birthday)
#    expect(page).to have_content(@user.gender)
    expect(page).to have_selector('input[type=radio][checked=checked][value=female]')
    expect(page).to have_link("Deactivate account")
  end
end