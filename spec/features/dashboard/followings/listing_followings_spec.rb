require 'rails_helper'

RSpec.feature "Listing Followings" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    @foo = FactoryGirl.create(:user)
    @bar = FactoryGirl.create(:user)
    @car = FactoryGirl.create(:user)
    
    @following = Following.create(user: @foo, follower: @bar)
    @following = Following.create(user: @car, follower: @foo)
  end
  
  scenario "Shows list of owner's followers", js: true do
    login_as(@foo, :scope => :user)
    visit(dashboard_path(@foo))
    click_link "Followers"
    
    expect(page).to have_content(Following.follower_active.where(user: @foo).count)
    expect(page).to have_content("Followers: 1")
    expect(page).to have_content(@bar.full_name) 
  end
  
  scenario "Shows list of users who owner follows", js: true do
    login_as(@foo, :scope => :user)
    visit(dashboard_path(@foo))
    click_link "Following"
    
    expect(page).to have_content(Following.following_active.where(follower_id: @foo).count)
    expect(page).to have_content("Following: 1")
    expect(page).to have_content(@car.full_name) 
    expect(page).to have_content("Unfollow")
  end
  
  scenario "Shows list of user's followers", js: true do
    
    visit(dashboard_path(@foo))
    expect(page).to have_content(Following.follower_active.where(user: @foo).count)
    
    click_link "Followers"
    expect(page).to have_content("Followers: 1")
    expect(page).to have_content(@bar.full_name) 
  end
  
  scenario "Shows list of users who owner follows", js: true do
    
    visit(dashboard_path(@foo))
    expect(page).to have_content(Following.following_active.where(follower_id: @foo).count)
    click_link "Following"
    
    expect(page).to have_content("Following: 1")
    expect(page).to have_content(@car.full_name) 
  end
end
