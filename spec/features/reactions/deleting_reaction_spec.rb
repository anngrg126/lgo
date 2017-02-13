require "rails_helper"

RSpec.feature "Deleting Reaction_Lol" do
  before do
    @bar = FactoryGirl.create(:user_with_published_stories)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story_foo = Story.where(author_id: @foo.id).active.first
    @story_bar = Story.where(author_id: @bar.id).active.first
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
    
    within '#top_reactions_bar' do
      page.click_link('', :href => reaction_path(Reaction.where(user_id: @foo.id, reaction_category_id: ReactionCategory.where(name: "lol").first.id, story_id: @story_bar.id).first.id))
      expect('#lol_count').to have_content('')
      page.click_link('', :href => reaction_path(Reaction.where(user_id: @foo.id, reaction_category_id: ReactionCategory.where(name: "like").first.id, story_id: @story_bar.id).first.id))
      expect('#like_count').to have_content('')
      page.click_link('', :href => reaction_path(Reaction.where(user_id: @foo.id, reaction_category_id: ReactionCategory.where(name: "love").first.id, story_id: @story_bar.id).first.id))
      expect('#love_count').to have_content('')
      page.click_link('', :href => reaction_path(Reaction.where(user_id: @foo.id, reaction_category_id: ReactionCategory.where(name: "omg").first.id, story_id: @story_bar.id).first.id))
      expect('#omg_count').to have_content('')
    end
  end
end