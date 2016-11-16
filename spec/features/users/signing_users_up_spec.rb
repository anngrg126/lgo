require 'rails_helper'
require 'support/macros'

RSpec.feature "Users signup" do
  
  before do
    @email = Faker::Internet.email
    @password = Faker::Internet.password
    @password2 = Faker::Internet.password
    @birthday = Faker::Date.birthday(min_age = 18, max_age = 65)
  end
  
  scenario "with valid credentials" do
    visit "/"
    
    click_link "Sign up"
    fill_in "Email", with: @email
    fill_in "Password", with: @password
    
    click_button "Sign up"
    
    expect(page.current_path).to eq(registration_step_path(:basic_details)) 
    expect(page).not_to have_content("Signed in as #{@email}")
    expect(page).not_to have_link("Sign out")
    
    fill_in "First Name", with: Faker::Name.first_name
    fill_in "Last Name", with: Faker::Name.last_name
    select_date @birthday, :from => "user_birthday"
    choose('user_gender_female')
    
    click_button "Submit"
    
    expect(page).to have_content("You have signed up successfully.")
    expect(page).to have_content("Signed in as #{@email}")
    expect(page).to have_link("Sign out")
    expect(page.current_path).to eq(dashboard_path(User.find_by(email: @email).slug)) 
  end
  
  scenario "with invalid credentials - step 1" do
    visit "/"
    
    click_link "Sign up"
    fill_in "Email", with: ""
    fill_in "Password", with: ""
    
    click_button "Sign up"
    
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end
  
  scenario "with invalid credentials - step 2", :js => true do
    visit "/"
    
    click_link "Sign up"
    fill_in "Email", with: Faker::Internet.email
    fill_in "Password", with: @password2
    
    click_button "Sign up"
    
    click_button "Submit"
    
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Birthday can't be blank")
    expect(page).to have_content("Gender can't be blank")
  end
  
  scenario "with valid credentials (custom gender) - step 2", :js => true do
    visit "/"
    
    click_link "Sign up"
    fill_in "Email", with: Faker::Internet.email
    fill_in "Password", with: @password2
    
    click_button "Sign up"
    
    fill_in "First Name", with: Faker::Name.first_name
    fill_in "Last Name", with: Faker::Name.last_name
    select_date @birthday, :from => "user_birthday"
    
    expect(page).not_to have_css("input#free_system_input")
    choose('custom_defined_gender')
    
    expect(page).to have_css("input#free_system_input")
    fill_in "free_system_input", with: "custom"
    
    click_button "Submit"
    
    expect(page).to have_content("You have signed up successfully.")
  end
end