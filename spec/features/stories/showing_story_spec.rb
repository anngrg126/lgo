require 'rails_helper'

RSpec.feature "Showing Stories" do 
  before do
    @bar = FactoryGirl.create(:user)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story =Story.where(author_id: @foo.id).where(deleted_at: nil).first
    
  end
  
  scenario "A non-signed in user does not see edit or delete links" do
    visit "/"
    
    click_link @story.final_title
    
    expect(page).to have_content(@story.final_title)
    expect(page).to have_content(@story.final_body)
    expect(page).to have_content("Posted by: #{@foo.full_name}")
    expect(current_path).to eq(story_path(@story))
    
    expect(page).not_to have_link("Edit Story")
    expect(page).not_to have_link("Delete Story")
    expect(page).to have_css("img[src*='image.png']")
    expect(page).to have_css("img[src*='mainimage.png']")
  end
  
  scenario "A non-owner signed in does not see edit or delete links" do
    login_as(@bar, :scope => :user)
    
    visit "/"
    
    click_link @story.final_title
    
    expect(page).to have_content(@story.final_title)
    expect(page).to have_content(@story.final_body)
    expect(current_path).to eq(story_path(@story))
    expect(page).to have_content("Posted by: #{@foo.full_name}")
    
    expect(page).not_to have_link("Edit Story")
    expect(page).not_to have_link("Delete Story")
  end
  
  scenario "A signed-in owner sees both edit and delete links" do
    login_as(@foo, :scope => :user)
    
    visit "/"
    
    click_link @story.final_title
    
    expect(page).to have_content(@story.final_title)
    expect(page).to have_content(@story.final_body)
    expect(current_path).to eq(story_path(@story))
    expect(page).to have_content("Posted by: #{@foo.full_name}")
    
    expect(page).to have_link("Edit Story")
    expect(page).to have_link("Delete Story")
  end
  
  scenario "Display individual story" do
    visit "/"
    
    click_link @story.final_title
    
    expect(page).to have_content(@story.final_title)
    expect(page).to have_content(@story.final_body)
    expect(page).to have_content("Posted by: #{@foo.full_name}")
    expect(current_path).to eq(story_path(@story))
  end
end