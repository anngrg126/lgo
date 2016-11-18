require "rails_helper"

RSpec.feature "Deleting Reaction_Lol" do
  before do
    @bar = FactoryGirl.create(:user_with_published_stories)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story_foo = Story.where(author_id: @foo.id).not_deleted.first
    @story_bar = Story.where(author_id: @bar.id).not_deleted.first
    ReactionCategory.create([
      {id: 1, name: 'like'}, 
      {id: 2, name: 'omg'}, 
      {id: 3, name: 'lol'}, 
      {id: 4, name: 'cool'}, 
      {id: 5, name: 'love'}
    ])
    Reaction.create([
      {user: @foo, story: @story_bar, reaction_category_id: 1},
      {user: @foo, story: @story_bar, reaction_category_id: 2},
      {user: @foo, story: @story_bar, reaction_category_id: 3},
      {user: @foo, story: @story_bar, reaction_category_id: 4},
      {user: @foo, story: @story_bar, reaction_category_id: 5},
    ])
  end
  
  scenario "A user succeeds", :js => true do
    login_as(@foo, :scope => :user)
    
    visit "/"
    click_link @story_bar.final_title 
    click_on "UnLike"
    click_on "UnOMG"
    click_on "UnLOL"
    click_on "UnCool"
    click_on "UnLove"
    
    expect(page).to have_content("Likes: 0")
    expect(page).to have_content("OMGs: 0")
    expect(page).to have_content("LOLs: 0")
    expect(page).to have_content("Cools: 0")
    expect(page).to have_content("Loves: 0")
    
    expect(page).to have_link("Like Story")
    expect(page).to have_link("OMG Story")
    expect(page).to have_link("LOL Story")
    expect(page).to have_link("Cool Story")
    expect(page).to have_link("Love Story")
    expect(page).not_to have_link("UnLike Story")
    expect(page).not_to have_link("UnOMG Story")
    expect(page).not_to have_link("UnLOL Story")
    expect(page).not_to have_link("UnCool Story")
    expect(page).not_to have_link("UnLove Story")
  end
end