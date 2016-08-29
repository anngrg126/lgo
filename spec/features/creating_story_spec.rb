require 'rails_helper'

RSpec.feature "Creating Stories" do 
  scenario "A user creates a new story" do
    visit "/"
    
    click_link "New Story"
    
    fill_in "Title", with: "Creating first story"
    fill_in "Body", with: "Lorem Ipsum"
    click_button "Create Story"
    
    expect(page).to have_content("Story has been submitted")
    expect(page.current_path).to eq(stories_path)
    
  end
end