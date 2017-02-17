require "rails_helper"

RSpec.feature "Adding Reaction_Lol to Stories" do
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @bar = FactoryGirl.create(:user)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story = Story.where(author_id: @foo.id).active.first
    ReactionCategory.create([
      {id: 1, name: 'like'}, 
      {id: 2, name: 'omg'}, 
      {id: 3, name: 'lol'}, 
      {id: 4, name: 'cool'}, 
      {id: 5, name: 'love'}
      ])
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
      ])
  end
  
  scenario "Permit a signed in user to lol a story", :js => true do
    login_as(@bar, :scope => :user)
    
    visit "/"
    click_link @story.final_title
    
    within '#top_reactions_bar' do
      page.click_link('', :href => reactions_path(user_id: @bar.id, story_id: @story.id, reaction_category_id: ReactionCategory.where(name: "lol").first.id))
      within '#lol_count' do
          expect(page).to have_content('1')
      end
      page.click_link('', :href => reactions_path(user_id: @bar.id, story_id: @story.id, reaction_category_id: ReactionCategory.where(name: "like").first.id))
      within '#like_count' do
        expect(page).to have_content('1')
      end
      page.click_link('', :href => reactions_path(user_id: @bar.id, story_id: @story.id, reaction_category_id: ReactionCategory.where(name: "love").first.id))
      within '#love_count' do
        expect(page).to have_content('1')
      end
      page.click_link('', :href => reactions_path(user_id: @bar.id, story_id: @story.id, reaction_category_id: ReactionCategory.where(name: "omg").first.id))
      within '#omg_count' do
        expect(page).to have_content('1')
      end
    end
    
    expect(page.current_path).to eq(story_path(@story))
    
    logout(:user)
    
    login_as(@foo, :scope => :user)
    visit "/"
    click_link "Notifications"
    
    expect(page).to have_content("#{@bar.full_name} liked your story #{@story.final_title}")
    expect(page).to have_content("#{@bar.full_name} reacted to your story #{@story.final_title}", count: 3)
    # expect(page).to have_content("#{@bar.full_name} OMG'd your story #{@story.final_title}")
#    expect(page).to have_content("#{@bar.full_name} LOL'd your story #{@story.final_title}")
    # expect(page).to have_content("#{@bar.full_name} Cool'd your story #{@story.final_title}")
    # expect(page).to have_content("#{@bar.full_name} Loved your story #{@story.final_title}")
    expect(page).to have_link(@bar.full_name)
    expect(page).to have_link(@story.final_title)
  end
  
  scenario "A non-signed in user fails to lol a story" do
    visit "/"
    click_link @story.final_title
    
    within '#top_reactions_bar' do
      page.click_link('', :href => reactions_path(user_id: 0, story_id: @story.id, reaction_category_id: ReactionCategory.where(name: "lol").first.id))
    end
    
    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page.current_path).to eq(new_user_session_path)
  end
end
