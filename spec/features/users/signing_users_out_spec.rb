require 'rails_helper'

RSpec.feature "Signing out signed-in users" do
  
  before do
    @foo = FactoryGirl.create(:user)
 
    visit "/"
    
    click_link "Login"
    fill_in "Email", with: @foo.email
    fill_in "Password", with: @foo.password
    click_button "Log in"
  end
  
  scenario do
    
    visit "/"
    
    click_link "Sign out"
    expect(page).to have_content("Signed out successfully.")
  end
end