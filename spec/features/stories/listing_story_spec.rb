require 'rails_helper'

RSpec.feature "Listing Stories" do 
  before do
    @user = FactoryGirl.create(:user_with_published_stories, stories_count: 2)
    @story1 = Story.where(author_id: @user.id).where(deleted_at: nil).first
    @story2 = Story.where(author_id: @user.id).where(deleted_at: nil).last
    @anonymous_user = FactoryGirl.create(:anonymous_user, id: 1000)
    @user1 = FactoryGirl.create(:user_with_published_anonymous_stories, stories_count: 1)
    @story3 = Story.friendly.find_by(author_id: @user1.id)
  end
  
  scenario "List all stories" do
    visit "/"
    
    expect(page).to have_content(@story1.final_title)
    expect(page).to have_content(@story1.final_body.truncate(150))
    expect(page).to have_content(@story2.final_title)
    expect(page).to have_content(@story2.final_body.truncate(150))
    expect(page).to have_link(@story1.final_title)
    expect(page).to have_link(@story2.final_title)
    expect(page).not_to have_link("New Story")
    expect(page).to have_content("Posted by: #{@user.full_name}")
    expect(page).to have_css("img[src*='mainimage.png']", count: 3)
  end
  
  scenario "List anonymous stories" do
    visit "/"
    
    expect(page).to have_content(@story3.final_title)
    expect(page).to have_content(@story3.final_body.truncate(150))
    expect(page).to have_content("Posted by: #{@anonymous_user.first_name} #{@anonymous_user.last_name}")
    expect(page).not_to have_content("Posted by: #{@user1.full_name}")
  end
end