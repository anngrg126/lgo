class DashboardController < ApplicationController
  before_action :set_user, only: [:show, :authored_stories, :bookmarked_stories, :commented_stories, :reacted_stories, :followings, :followers, :notifications, :user_profile]
  before_action :set_anonymous_user
  before_action :set_tags
  
  before_action :set_dashboard_stories, only: [:show, :authored_stories, :notifications, :bookmarked_stories]  
  before_action :set_bookmarked_stories, only: [:show, :notifications, :bookmarked_stories]
  before_action :set_commented_stories, only: [:show, :commented_stories, :notifications, :bookmarked_stories]
  before_action :set_reacted_stories, only: [:show, :reacted_stories, :notifications, :bookmarked_stories]
  before_action :set_notifications, only: [:show, :notifications, :bookmarked_stories]
  before_action :set_bookmark_posters, only: [:bookmarked_stories]
  before_action :set_reaction_posters, only: [:reacted_stories]
  before_action :set_commented_story_posters, only:  [:commented_stories]
  before_action :set_followers, only: [:show, :followers, :notifications, :bookmarked_stories]
  before_action :set_followings, only: [:show, :followings, :notifications, :bookmarked_stories]
  before_action :set_current_user_followings, only: [:followings, :followers]
    
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
#    @user = User.includes(:stories, :followers, :followings).friendly.find(params[:id])
    if @user == current_user
      @user = User.includes(:stories, :followers, :followings, :notifications).friendly.find(params[:id])
      #note: can make more efficient by also including reactions, and moving set_reacted_stories to a nested route in def show. Same for bookmarks.
    else
      @user = User.includes(:stories, :followers, :followings).friendly.find(params[:id])
    end
  end
  
  def set_dashboard_stories
    unless @user == current_user
      unless @user == @anonymous_user
        @dashboard_stories = @user.stories.select {|s| s.poster_id == @user.id && s.active? && s.published?}
      else
        @dashboard_stories = @user.stories_posted.select {|s| s.active? && s.published?}
      end
    else
      @dashboard_stories = @user.stories.select {|s| s.active?}
    end
    @dashboard_stories.uniq!
  end
  
  def set_notifications
    @notifications = @user.notifications.includes(:notification_category)
    
    unless @notifications.select{|n| n.read == false}.empty? 
      @unread_notifications = @notifications.select{|n| n.read == false}
    else 
      @unread_notifications = []
    end
    
    unless @notifications.select{|n| n.read == true}.empty? 
      @read_notifications = @notifications.select{|n| n.read == true}
    else 
      @read_notifications = []
    end 
  end
 
  def set_reacted_stories
    @reacted_stories = []
    @user.reactions.includes(:story).select{|r| r.story.active? }.each do |reaction|
      if @user == current_user
        unless reaction.story.author_id == @user.id
          @reacted_stories.push(reaction.story)
        end
      else
        @reacted_stories.push(reaction.story)
      end
    end
    @reacted_stories.uniq!
  end
  
  def set_reaction_posters
    @r_posters_query = []
    @reacted_stories.each do |r|
      @r_posters_query.push(r.poster_id)
    end
    @r_posters_query.uniq!  
    @r_posters = User.find(@r_posters_query)
  end
  
  def set_bookmarked_stories
    @bookmarked_stories = []
    @user.bookmarks.includes(:story).select{ |b| b.story.active? }.each do |bookmark|
      unless bookmark.story.author_id == @user.id
        @bookmarked_stories.push(bookmark.story)
      end
    end
    @bookmarked_stories.uniq!
  end
  
  def set_bookmark_posters
    @b_posters_query = []
    @bookmarked_stories.each do |b|
      @b_posters_query.push(b.poster_id)
    end
    @b_posters_query.uniq!  
    @b_posters = User.find(@b_posters_query)
  end
  
  def set_commented_stories
    @commented_stories = []
    @user.comments.includes(:story).select{ |c| c.story.active? }.each do |comment|
      unless comment.story.author_id == @user.id
        @commented_stories.push(comment.story)
      end
    end
    @commented_stories.uniq!
  end
  
  def set_commented_story_posters
    @c_posters_query = []
    @commented_stories.each do |c|
      @c_posters_query.push(c.poster_id)
    end
    @c_posters_query.uniq!  
    @c_posters = User.find(@c_posters_query)
  end
  
  def set_followers
    @followers = @user.followers.select{ |f| f.deactivated_at==nil }
    #yields a collection of Users
  end
  
  def set_followings
    @followings = User.joins(:followings).where(:followings => { follower_id: @user.id}).select{ |f| f.deactivated_at==nil }
    #yields a collection of Users
  end
  
  def set_current_user_followings
    if current_user
      @current_user_followers = current_user.following_users
    end
  end
  
  def set_tags
    @tags = Tag.alltags
  end
  
  def set_anonymous_user
    @anonymous_user = User.where(anonymous: true).first
  end
end