require 'rails_helper'

RSpec.feature "Showing Stories" do 
  before do
    @foo = User.create(email: "foo@bar.com", password: "password")
    @foobar = User.create(email: "foobar@bar.com", password: "password")
    @story = Story.create(title: "The first story", body: "Body of first story", user: @foo)
  end
  
  scenario "A non-signed in user does not see edit or delete links" do
    visit "/"
    
    click_link @story.title
    
    expect(page).to have_content(@story.title)
    expect(page).to have_content(@story.body)
    expect(current_path).to eq(story_path(@story))
    
    expect(page).not_to have_link("Edit Story")
    expect(page).not_to have_link("Delete Story")
  end
  
  scenario "A non-owner signed in does not see edit or delete links" do
    login_as(@foobar)
    
    visit "/"
    
    click_link @story.title
    
    expect(page).to have_content(@story.title)
    expect(page).to have_content(@story.body)
    expect(current_path).to eq(story_path(@story))
    
    expect(page).not_to have_link("Edit Story")
    expect(page).not_to have_link("Delete Story")
  end
  
  scenario "Display individual story" do
    visit "/"
    
    click_link @story.title
    
    expect(page).to have_content(@story.title)
    expect(page).to have_content(@story.body)
    expect(current_path).to eq(story_path(@story))
  end
  
end