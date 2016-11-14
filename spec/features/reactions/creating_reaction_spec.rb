require "rails_helper"

RSpec.feature "Adding Reaction_Lol to Stories" do
  before do
    @bar = FactoryGirl.create(:user)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story = Story.find_by(author_id: @foo.id)
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
  
    click_on "Like Story"
    click_on "OMG Story"
    click_on "LOL Story"
    click_on "Cool Story"
    click_on "Love Story"
    
    expect(page).to have_content("Likes: 1")
    expect(page).to have_content("OMGs: 1")
    expect(page).to have_content("LOLs: 1")
    expect(page).to have_content("Cools: 1")
    expect(page).to have_content("Loves: 1")
    expect(page.current_path).to eq(story_path(@story))
    
    logout(:user)
    
    login_as(@foo, :scope => :user)
    visit "/"
    click_link "Notifications"
    
    expect(page).to have_content("#{@bar.full_name} liked your story #{@story.final_title}")
    expect(page).to have_content("#{@bar.full_name} OMG'd your story #{@story.final_title}")
    expect(page).to have_content("#{@bar.full_name} LOL'd your story #{@story.final_title}")
    expect(page).to have_content("#{@bar.full_name} Cool'd your story #{@story.final_title}")
    expect(page).to have_content("#{@bar.full_name} Loved your story #{@story.final_title}")
    expect(page).to have_link(@bar.full_name)
    expect(page).to have_link(@story.final_title)
  end
  
  scenario "A non-signed in user fails to lol a story" do
    visit "/"
    click_link @story.final_title
    
    click_on "LOL Story"
    
    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page.current_path).to eq(new_user_session_path)
  end
end
