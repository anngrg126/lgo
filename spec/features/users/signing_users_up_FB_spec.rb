require 'rails_helper'

RSpec.feature "New users sign up via Facebook" do
  
  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # If using Devise
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end
  
  scenario "with valid credentials" do
    visit "/"
    
    click_link "Join"
    click_link "Sign in with Facebook"
    
    expect(page).to have_content("Successfully signed in from Facebook.")
    expect(page).to have_content("Signed in as example@test.com.")
    expect(page.current_path).to eq(dashboard_path(User.find_by(email: "example@test.com").slug)) 
    expect(page).to have_css('div#user_registration img')
  end
end
