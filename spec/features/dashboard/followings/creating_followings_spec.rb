require 'rails_helper'

RSpec.feature "ListingFollowings" do 
  before do
    @anonymous_user = FactoryGirl.create(:anonymous_user)
    NotificationCategory.create([
      {id: 1, name: "Story"},
      {id: 2, name: "Comment"},
      {id: 3, name: "Reaction"},
      {id: 4, name: "Bookmark"},
      {id: 5, name: "Following"}
    ])
    @foo = FactoryGirl.create(:user)
    @bar = FactoryGirl.create(:user)
    
    login_as(@foo, :scope => :user)
  end
  
  scenario "Logged-in user can't follow himself" do
    
    visit(dashboard_path(@foo))
    
    expect(page).to have_content(@foo.full_name)    
    expect(page).not_to have_link("Follow", href: "/followings?follower_id=#{@foo.id}&user_id=#{@foo.id}")
   end
  
  scenario "Logged-in user can follow others", :js => true do
    visit(dashboard_path(@bar))
    
    expect(page).to have_content(@bar.full_name) 
    
    link = "a[href='/followings?follower_id=#{@foo.id}&user_id=#{@bar.id}']"
    find(link).click
    
    expect(page).not_to have_link("Follow", href: "/followings?follower_id=#{@foo.id}&user_id=#{@bar.id}")
    expect(page).to have_content("You are now following #{@bar.full_name}")
    expect(page).to have_link("Unfollow")
     
  end
end
