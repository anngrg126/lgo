class DashboardController < ApplicationController
  before_action :set_user, only: [:show, :authored_stories, :bookmarked_stories, :commented_stories, :reacted_stories, :followings, :followers, :notifications, :user_profile]
  
  before_action :set_authored_stories, only: [:show, :authored_stories, :notifications, :bookmarked_stories]  
  before_action :set_posted_stories, only: [:show, :authored_stories, :notifications, :bookmarked_stories]  
  before_action :set_bookmarked_stories, only: [:show, :bookmarked_stories, :notifications, :bookmarked_stories]
  before_action :set_commented_stories, only: [:show, :commented_stories, :notifications, :bookmarked_stories]
  before_action :set_reacted_stories, only: [:show, :reacted_stories, :notifications, :bookmarked_stories]
  before_action :set_followers, only: [:show, :followers, :notifications, :bookmarked_stories]
  before_action :set_followings, only: [:show, :followings, :notifications, :bookmarked_stories]
  before_action :set_notifications, only: [:show, :notifications, :bookmarked_stories]
  
  def show
  end
  
  def authored_stories
    respond_to do |format|
      format.js {render :partial => 'dashboard/authored_stories'} 
    end
  end
  
  def bookmarked_stories
    respond_to do |format|
      format.js {render :partial => 'dashboard/bookmarked_stories'} 
      format.html
    end
  end
  
  def commented_stories
    respond_to do |format|
      format.js {render :partial => 'dashboard/commented_stories'} 
    end
  end
  
  def reacted_stories
    respond_to do |format|
      format.js {render :partial => 'dashboard/reacted_stories'}
    end
  end
  
  def followers
    respond_to do |format|
      format.js {render :partial => 'dashboard/followers'} 
    end
  end
  
  def followings
    respond_to do |format|
      format.js {render :partial => 'dashboard/followings'} 
    end
  end
  
  def notifications
    respond_to do |format|
      format.js {render :partial => 'dashboard/notifications'}
      format.html
    end
  end
  
  def user_profile
    respond_to do |format|
      format.js {render :partial => 'dashboard/user_profile'}
      format.html
    end
  end
  
  private
  
  def set_user
    @user = User.friendly.find(params[:id])
  end
  
  def set_authored_stories
    @authored_stories = Story.active.where(author_id: @user)
  end
  
  def set_posted_stories
    @posted_stories = Story.active.where(poster_id: @user)
  end
  
  def set_notifications
    @notifications = Notification.where(user_id: @user.id)
    @unread_notifications = @notifications.where(read: false)
    @read_notifications = @notifications.where(read: true)
  end
  
  def set_reacted_stories
    if @user == current_user
      @reacted_stories = Story.active.where.not(author_id: @user.id).joins(:reactions).where(:reactions => { :user_id => @user.id})
    else
      @reacted_stories = Story.active.joins(:reactions).where(:reactions => { :user_id => @user.id})
    end
  end
  
  def set_bookmarked_stories
    @bookmarked_stories = Story.active.where.not(author_id: @user.id).joins(:bookmarks).where(:bookmarks => { :user_id => @user.id})
  end
  
  def set_commented_stories
    @commented_stories = Story.active.joins(:comments).where(:comments => { :user_id => @user.id, :deleted_at => nil})
  end
  
  def set_followers
    @followers = Following.follower_active.where(user_id: @user.id)
  end
  
  def set_followings
    @followings = Following.following_active.where(follower_id: @user.id)
  end
end