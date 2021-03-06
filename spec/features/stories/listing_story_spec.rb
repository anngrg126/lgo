require 'rails_helper'

RSpec.feature "Listing Stories" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @anonymous_user.update_attributes(id: 1)
    @user = FactoryGirl.create(:user_with_published_stories, stories_count: 2)
    @story1 = Story.where(author_id: @user.id).active.first
    @story2 = Story.where(author_id: @user.id).active.last
    @user1 = FactoryGirl.create(:user_with_published_anonymous_stories, stories_count: 1)
    @story3 = Story.friendly.find_by(author_id: @user1.id)
    @user2 = FactoryGirl.create(:user_with_published_updated_stories, stories_count: 1)
    @story4 = Story.friendly.find_by(author_id: @user2.id)
  end
  
  scenario "List all stories" do
    visit "/"
    
    expect(page).to have_link(@story1.final_title)
    expect(page).to have_content(@story1.final_body.truncate(150))
    expect(page).to have_content(@story1.final_gift_description)
    expect(page).to have_link(@story2.final_title)
    expect(page).to have_content(@story2.final_body.truncate(150))
    expect(page).to have_content(@story2.final_gift_description)
    
    expect(page).not_to have_link("New Story")
    expect(page).to have_link("#{@user.full_name}")
#    expect(page).to have_css("img[src*='mainimage.png']", count: 4)
    expect(page).to have_css('div.story-card-image', count: 4)
  end
  
  scenario "List anonymous stories" do
    visit "/"
    
    expect(page).to have_content(@story3.final_title)
    expect(page).to have_content(@story3.final_body.truncate(150))
    expect(page).to have_link("#{@anonymous_user.first_name} #{@anonymous_user.last_name}")
    expect(page).not_to have_content("#{@user1.full_name}")
  end
  
  scenario "List published updated stories" do
    visit "/"
    
    expect(page).to have_content(@story4.updated_title)
    expect(page).to have_content(@story4.updated_body.truncate(150))
    expect(page).to have_content(@story4.updated_gift_description)
    expect(page).to have_link("#{@user2.first_name} #{@user2.last_name}")
  end
end