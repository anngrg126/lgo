require 'rails_helper'

RSpec.feature "Listing Reacted Stories" do 
  before do
    @author = FactoryGirl.create(:user_with_published_stories, stories_count: 3)
    @user = FactoryGirl.create(:user_with_published_stories)
    @story1 = Story.where(author_id: @author.id).not_deleted.first
    @story2 = Story.where(author_id: @author.id).not_deleted.second
    @story3 = Story.where(author_id: @author.id).not_deleted.last
    @story4 = Story.where(author_id: @user.id).not_deleted.first
    
    ReactionCategory.create([
      {id: 1, name: 'like'}, 
      {id: 2, name: 'omg'}, 
      {id: 3, name: 'lol'}, 
      {id: 4, name: 'cool'}, 
      {id: 5, name: 'love'}
      ])
    
    @reaction1 = Reaction.create(user_id: @user.id, story_id: @story1.id, reaction_category_id: 1)
    @reaction2 = Reaction.create(user_id: @user.id, story_id: @story2.id, reaction_category_id: 2)
    @reaction3 = Reaction.create(user_id: @author.id, story_id: @story3.id, reaction_category_id: 3)
    @reaction4 = Reaction.create(user_id: @user.id, story_id: @story4.id, reaction_category_id: 5)
    
    login_as(@user, :scope => :user)
  end
  
  scenario "Logged-in user can see the list of the stories where she's reacted", js: true do
    visit(dashboard_path(@user))
    click_link "Reactions"
    
    expect(page).to have_content("Reactions: 2")

    expect(page).to have_content(@story1.final_title)
    expect(page).to have_content(@story1.final_body.truncate(150))
    expect(page).to have_link(@story1.final_title)
    expect(page).to have_content("Like")
    
    expect(page).to have_content(@story2.final_title)
    expect(page).to have_content(@story2.final_body.truncate(150))
    expect(page).to have_link(@story2.final_title)
    expect(page).to have_content("OMG")
    
    expect(page).not_to have_content(@story3.final_title)
    expect(page).not_to have_content(@story3.final_body.truncate(150))
    expect(page).not_to have_link(@story3.final_title)
    expect(page).not_to have_content("LOL")
    
    expect(page).to have_css("img[src*='mainimage.png']", count: 2)
   end
end