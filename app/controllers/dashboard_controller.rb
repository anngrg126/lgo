class DashboardController < ApplicationController
  before_action :set_user, only: [:show, :authored_stories, :bookmarked_stories, :commented_stories, :followings, :followers, :notifications]
  
  before_action :set_authored_stories, only: [:show, :authored_stories, :notifications]  
  before_action :set_posted_stories, only: [:show, :authored_stories, :notifications]  
  before_action :set_bookmarked_stories, only: [:show, :bookmarked_stories, :notifications]
  before_action :set_commented_stories, only: [:show, :commented_stories, :notifications]
  before_action :set_followers, only: [:show, :followers, :notifications]
  before_action :set_followings, only: [:show, :followings, :notifications]
  before_action :set_notifications, only: [:show, :notifications]
  
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
    end
  end
  
  def commented_stories
    respond_to do |format|
      format.js {render :partial => 'dashboard/commented_stories'} 
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
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_authored_stories
    @authored_stories = Story.where(author_id: @user)
  end
  
  def set_posted_stories
    @posted_stories = Story.where(poster_id: @user)
  end
  
  def set_notifications
    @notifications = Notification.where(user_id: @user.id)
    @unread_notifications = Notification.where(user_id: @user.id, read: false)
  end
  
#  def set_liked_stories
#    if @user == current_user
#      @liked_stories = Story.where.not(author_id: @user.id).joins(:story_likes).where(:story_likes => { :user_id => @user.id})
#    else
#      @liked_stories = Story.joins(:story_likes).where(:story_likes => { :user_id => @user.id})
#    end
#  end
  
  def set_bookmarked_stories
    @bookmarked_stories = Story.where.not(author_id: @user.id).joins(:bookmarks).where(:bookmarks => { :user_id => @user.id})
  end
  
  def set_commented_stories
    @commented_stories = Story.joins(:comments).where(:comments => { :user_id => @user.id})
  end
  
  def set_followers
    @followers = Following.where(user_id: @user.id)
  end
  
  def set_followings
    @followings = Following.where(follower_id: @user.id)
  end
end