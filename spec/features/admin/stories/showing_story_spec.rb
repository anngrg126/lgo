require 'rails_helper'

RSpec.feature "Showing Stories" do 
  before do
    @user = FactoryGirl.create(:user_with_unpublished_stories)
    @user2 = FactoryGirl.create(:user_with_unpublished_review_stories)
    @admin = FactoryGirl.create(:admin)
    @story = Story.where(author_id: @user.id).active.first
    @story2 = Story.where(author_id: @user2.id).active.first
    login_as(@admin, :scope => :user)
    
  end
  
  scenario "Logged-in admin can see individual story" do
    visit "/admin"
    
    click_link @story.raw_title
    expect(page).to have_content("#{@story.user(:author_id).full_name}")
    expect(page).to have_content(@story.created_at.strftime("%b %d, %Y"))
    expect(page).to have_content("Unpublished")
    expect(page).to have_content("User requested a GiftOn editor to add a light touch? No")
    expect(page).to have_content(@story.raw_title)
    expect(page).to have_content(@story.raw_body)
    expect(page).to have_css("img[src*='image.png']")
    expect(current_path).to eq(admin_story_path(@story))
    expect(page).to have_link("Edit Story")
    expect(page).to have_link("Delete Story")
  end
  
  scenario "Logged-in admin can see individual story - with review request" do
    visit "/admin"
    
    click_link @story2.raw_title
    expect(page).to have_content("User requested a GiftOn editor to add a light touch? YES")
  end
end