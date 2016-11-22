require 'rails_helper'

RSpec.feature "Deleting Stories" do 
  
  before do
    @user = FactoryGirl.create(:user_with_unpublished_stories)
    @admin = FactoryGirl.create(:admin)
    login_as(@admin, :scope => :user)
    @story = Story.where(author_id: @user.id).active.first
    
  end
  
  scenario "A user deletes a story" do
    visit "/admin"
    
    click_link @story.raw_title
    
    click_link "Delete Story"
    
    expect(page).to have_content("Story has been deleted")
    expect(page.current_path).to eq(admin_stories_path)   
  end
end
