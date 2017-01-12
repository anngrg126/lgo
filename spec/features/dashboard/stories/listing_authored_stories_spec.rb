require 'rails_helper'

RSpec.feature "Listing Stories" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @user = FactoryGirl.create(:user_with_unpublished_stories, stories_count: 4)
    @story1 = Story.where(author_id: @user.id).active.first
    @story2 = Story.where(author_id: @user.id).active.second
    @story3 = Story.where(author_id: @user.id).active.third
    @story4 = Story.where(author_id: @user.id).active.last
    @story3.update(published: true, final_title: Faker::Hipster.sentence, final_body: Faker::Hipster.paragraph, poster_id: @user.id, last_user_to_update: "Admin", main_image: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/mainimage.png', 'image/png') )
    @story4.update(published: true, final_title: Faker::Hipster.sentence, final_body: Faker::Hipster.paragraph, anonymous: true, poster_id: @anonymous_user.id, last_user_to_update: "Admin", main_image: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/mainimage.png', 'image/png') )
    @visitor = FactoryGirl.create(:user)
  end
  
  scenario "Logged-in user can see full list of her published, unpublished, and anonymous stories" do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    expect(page).to have_content("Stories: 4")
    
    expect(page).to have_content(Story.where(author_id: @user.id, deleted_at: nil).count)
    expect(page).to have_content(@story1.raw_title)
    expect(page).to have_content(@story1.raw_body.truncate(150))
    expect(page).to have_link(@story1.raw_title)
    expect(page).to have_content(@story2.raw_title)
    expect(page).to have_content(@story2.raw_body.truncate(150))
    expect(page).to have_link(@story2.raw_title)
    expect(page).to have_content(@story3.final_title)
    expect(page).to have_content(@story3.final_body.truncate(150))
    expect(page).to have_link(@story3.final_title)
    expect(page).to have_content("Pending")
    
    expect(page).to have_content(@story4.final_title)
    expect(page).to have_content(@story4.final_body.truncate(150))
    expect(page).to have_link(@story4.final_title)
    expect(page).to have_content("Anonymous")
    
    expect(page).to have_css("img[src*='mainimage.png']", count: 2)
   end
  
  scenario "Logged-in user can click back to her full list of published and unpublished stories", js: true do
    login_as(@user, :scope => :user)
    visit(dashboard_path(@user))
    click_link "Saves"
    click_link "Stories"
    
    expect(page).to have_content("List of all Authored Stories")
    expect(page).to have_content(@story1.raw_title)
    expect(page).to have_content(@story1.raw_body.truncate(150))
    expect(page).to have_link(@story1.raw_title)
    expect(page).to have_content(@story2.raw_title)
    expect(page).to have_content(@story2.raw_body.truncate(150))
    expect(page).to have_link(@story2.raw_title)
    expect(page).to have_content(@story3.final_title)
    expect(page).to have_content(@story3.final_body.truncate(150))
    expect(page).to have_link(@story3.final_title)
    expect(page).to have_content(@story4.final_title)
    expect(page).to have_content(@story4.final_body.truncate(150))
    expect(page).to have_link(@story4.final_title)
    expect(page).to have_content("Anonymous")
   end
  
  scenario "Non-owner can only see another user's published and non-anonymous stories" do
    login_as(@visitor, :scope => :user)
    visit(dashboard_path(@user))
    
    expect(page).to have_content(@story3.final_title)
    expect(page).to have_content(@story3.final_body.truncate(150))
    expect(page).to have_link(@story3.final_title)
    
    expect(page).not_to have_content(@story1.raw_title)
    expect(page).not_to have_content(@story1.raw_body.truncate(150))
    expect(page).not_to have_link(@story1.raw_title)
    expect(page).not_to have_content(@story4.final_title)
    expect(page).not_to have_content(@story4.final_body.truncate(150))
    expect(page).not_to have_link(@story4.final_title)   
    
    visit(dashboard_path(@anonymous_user))
    expect(page).to have_content(@story4.final_title)
    expect(page).to have_content(@story4.final_body.truncate(150))
    expect(page).to have_link(@story4.final_title) 
  end
end