require 'rails_helper'
require 'support/macros'

RSpec.feature "Searching for a story", :type => :feature do 
  
  before do
    @user = FactoryGirl.create(:user)
    @foo = FactoryGirl.create(:user_with_published_stories)
    @story_foo = Story.where(author_id: @foo.id).active.first
    TagCategory.create([
      {id: 1, category: "Relationship"},
      {id: 2, category: "Occasion"},
      {id: 3, category: "Type"},
      {id: 4, category: "Interests"},
      {id: 5, category: "To_recipient"},
      {id: 6, category: "Gifton_reaction"},
      {id: 7, category: "Collection"}
      ])
    Tag.create([
      {  id: 1, tag_category_id: 1 , name: 'family' },
      {  id: 2, tag_category_id: 1 , name: 'parents' },
      {  id: 3, tag_category_id: 5 , name: 'brother' },
      {  id: 4, tag_category_id: 5 , name: 'mother' },
      {  id: 5, tag_category_id: 2 , name: 'anniversary' },
      {  id: 6, tag_category_id: 2 , name: 'birthday' },
      {  id: 7, tag_category_id: 2 , name: 'fail' }
      ])
  end
  
  scenario "A logged in user searches for a query in title" do
    
    if @story_foo.updated_title.nil?
      @search_word = @story_foo.final_title.split.first
    else
      @search_word = @story_foo.updated_title.split.first
    end
    
    login_as(@user, :scope => :user)
    
    visit "/"
  
    click_button "btnSearch"
    
    within("#search_dropdown") do
      fill_in "search", with: @search_word
      click_button "Search"
    end
       
    expect(page).to have_content(@story_foo.final_title)
    expect(page).to have_content(@story_foo.final_body.truncate(275))
    expect(page).to have_link(@story_foo.final_title)
    expect(page).to have_link("#{@foo.full_name}")
#    expect(page).to have_css("img[src*='mainimage.png']", count: 1)
    expect(page).to have_css('div.story-card-image', count: 1)
    expect(page).not_to have_content("No stories matched : "+ @search_word)
    
    expect(SearchQueryLog.last.user_id).to eq (@user.id)
    expect(SearchQueryLog.last.query_string).to eq (@search_word)

  end
  
  scenario "A logged in user searches for a query in body" do
    
    if @story_foo.updated_body.nil?
      @search_word = @story_foo.final_body.split.first.remove("<div>")
    else
      @search_word = @story_foo.updated_body.split.first.remove("<div>")
    end
    
    login_as(@user, :scope => :user)
    
    visit "/"
  
    click_button "btnSearch"
    
    within("#search_dropdown") do
        fill_in "search", with: @search_word
        click_button "Search"
    end
       
    expect(page).to have_content(@story_foo.final_title)
    expect(page).to have_content(@story_foo.final_body.truncate(275))
    expect(page).to have_link(@story_foo.final_title)
    expect(page).to have_link("#{@foo.full_name}")
    expect(page).to have_css('div.story-card-image', count: 1)
    expect(page).not_to have_content("No stories matched : "+ @search_word)
    
    expect(SearchQueryLog.last.user_id).to eq (@user.id)
    expect(SearchQueryLog.last.query_string).to eq (@search_word)

  end
  
  scenario "A logged in user searches for a query in tags" do
    
    FactoryGirl.create(:classification, story_id: @story_foo.id)
    Story.reindex
    
    @search_word = @story_foo.tags.first.name
    
    login_as(@user, :scope => :user)
    
    visit "/"
  
    click_button "btnSearch"
    
    within("#search_dropdown") do
      fill_in "search", with: @search_word
      click_button "Search"
    end
       
    expect(page).to have_content(@story_foo.final_title)
    expect(page).to have_content(@story_foo.final_body.truncate(275))
    expect(page).to have_link(@story_foo.final_title)
    expect(page).to have_link("#{@foo.full_name}")
    expect(page).to have_css('div.story-card-image', count: 1)
    expect(page).not_to have_content("No stories matched : "+ @search_word)
    
    expect(SearchQueryLog.last.user_id).to eq (@user.id)
    expect(SearchQueryLog.last.query_string).to eq (@search_word)

  end
  
   scenario "A logged in user searches for a query in gift description" do
    
    if @story_foo.updated_gift_description.nil?
      @search_word = @story_foo.final_gift_description.split.first
    else
      @search_word = @story_foo.updated_gift_description.split.first
    end
    
    login_as(@user, :scope => :user)
    
    visit "/"
  
    click_button "btnSearch"
    
    within("#search_dropdown") do
      fill_in "search", with: @search_word
      click_button "Search"
    end
       
    expect(page).to have_content(@story_foo.final_title)
    expect(page).to have_content(@story_foo.final_body.truncate(275))
    expect(page).to have_link(@story_foo.final_title)
    expect(page).to have_link("#{@foo.full_name}")
    expect(page).to have_css('div.story-card-image', count: 1)
    expect(page).not_to have_content("No stories matched : "+ @search_word)
    
    expect(SearchQueryLog.last.user_id).to eq (@user.id)
    expect(SearchQueryLog.last.query_string).to eq (@search_word)

  end
  
  scenario "A non-logged in user searches for a query in title" do
    
    if @story_foo.updated_title.nil?
      @search_word = @story_foo.final_title.split.first
    else
      @search_word = @story_foo.updated_title.split.first
    end
    
    visit "/"
  
    click_button "btnSearch"
    
    within("#search_dropdown") do
        fill_in "search", with: @search_word
        click_button "Search"
    end
       
    expect(page).to have_content(@story_foo.final_title)
    expect(page).to have_content(@story_foo.final_body.truncate(275))
    expect(page).to have_link(@story_foo.final_title)
    expect(page).to have_link("#{@foo.full_name}")
    expect(page).to have_css('div.story-card-image', count: 1)
    expect(page).not_to have_content("No stories matched : "+ @search_word)
    
    expect(SearchQueryLog.last.user_id).to eq nil
    expect(SearchQueryLog.last.query_string).to eq (@search_word)

  end
  
  scenario "A logged in user searches for a query in that does not match any story" do
    
    @search_word = "xxxxxxxxxxxx"
    
    login_as(@user, :scope => :user)
    
    visit "/"
  
    click_button "btnSearch"
    
    within("#search_dropdown") do
      fill_in "search", with: @search_word
      click_button "Search"
    end
       
    expect(page).to have_content("No stories matched : "+ @search_word)
    
    expect(SearchQueryLog.last.user_id).to eq (@user.id)
    expect(SearchQueryLog.last.query_string).to eq (@search_word)
    expect(SearchQueryLog.last.result_count).to eq 0

  end
  
end