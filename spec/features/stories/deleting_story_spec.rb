require 'rails_helper'

RSpec.feature "Deleting Stories" do 
  
  before do
    @user = FactoryGirl.create(:user_with_published_stories)
    login_as(@user, :scope => :user)
    @story = Story.where(author_id: @user.id).where(deleted_at: nil).first
  end
  
  scenario "A user deletes a story" do
    visit "/"
    click_link @story.final_title
    
    click_link "Delete Story"
    expect(Story.find(@story.id).deleted_at).not_to be(nil)
    expect(page).to have_content("Story has been deleted")
    expect(page.current_path).to eq(stories_path)   
  end
end
