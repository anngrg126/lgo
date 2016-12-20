class DashboardController < ApplicationController
  before_action :set_user, only: [:show, :authored_stories, :bookmarked_stories, :commented_stories, :reacted_stories, :followings, :followers, :notifications, :user_profile]
  before_action :set_anonymous_user
  
  before_action :set_authored_stories, only: [:show, :authored_stories, :notifications, :bookmarked_stories]  
  before_action :set_posted_stories, only: [:show, :authored_stories, :notifications, :bookmarked_stories]  
  before_action :set_bookmarked_stories, only: [:show, :notifications, :bookmarked_stories]
  before_action :set_commented_stories, only: [:show, :commented_stories, :notifications, :bookmarked_stories]
  before_action :set_reacted_stories, only: [:show, :reacted_stories, :notifications, :bookmarked_stories]
  before_action :set_followers, only: [:show, :followers, :notifications, :bookmarked_stories]
  before_action :set_followings, only: [:show, :followings, :notifications, :bookmarked_stories]
  before_action :set_notifications, only: [:show, :notifications, :bookmarked_stories]
  before_action :set_tags
  before_action :set_bookmark_posters, only: [:bookmarked_stories]
  before_action :set_reaction_posters, only: [:reacted_stories]
  before_action :set_followings_users, only:  [:followings]
  before_action :set_commented_story_posters, only:  [:commented_stories]
  
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
#    @user = User.friendly.find(params[:id])
    @user = User.includes(:stories).friendly.find(params[:id])
    if @user == current_user
      @user = User.includes(:stories, :followers, :followings, :notifications).friendly.find(params[:id])
      #note: can make more efficient by also including reactions, and moving set_reacted_stories to a nested route in def show. Same for bookmarks.
    else
      @user = User.includes(:stories, :followers, :followings).friendly.find(params[:id])
    end
  end
  
  def set_authored_stories
#    @authored_stories = Story.active.where(author_id: @user)
    @authored_stories = @user.stories.active
  end
  
  def set_posted_stories
#    @posted_stories = Story.active.where(poster_id: @user)
#    unless @user.id == 3 || @user.id == 1000
    unless @user.id == @anonymous_user.id
      @postings = @user.stories.active.published.group_by(&:poster_id)
      unless @postings.select{|poster_id| poster_id == @user.id}.empty?
        @posted_stories = @postings.select{|poster_id| poster_id == @user.id}.first[1]
      else
        @posted_stories = []
      end
    else
      @posted_stories = Story.active.where(poster_id: @user)
    end
  end
  
  def set_notifications
#    @notifications = Notification.where(user_id: @user.id)
#    @read_notifications = @notifications.where(read: true)
#    @unread_notifications = @notifications.where(read: false)
    @notifications = @user.notifications.group_by(&:read)
    
    unless @notifications.select{|read| read == false}.empty? 
      @unread_notifications = @notifications.select{|read| read == false}.first[1]
    else 
      @unread_notifications = []
    end
    
    unless @notifications.select{|read| read == true}.empty? 
      @read_notifications = @notifications.select{|read| read == true}.first[1]
    else 
      @read_notifications = []
    end 
  end
  
  def set_reacted_stories
    @reacted_stories = []
    if @user == current_user
      @user.reactions.includes(:story).each do |reaction|
        if reaction.story.active?
          unless reaction.story.author_id == @user.id
            @reacted_stories.push(reaction.story)
          end
        end
      end
#      @reacted_stories = Story.active.where.not(author_id: @user.id).joins(:reactions).where(:reactions => { :user_id => @user.id})
    else
      @user.reactions.includes(:story).each do |reaction|
        if reaction.story.active?
          @reacted_stories.push(reaction.story)
        end
      end
#      @reacted_stories = Story.active.joins(:reactions).where(:reactions => { :user_id => @user.id})
    end
    @reacted_stories.uniq!
  end
  def set_reaction_posters
    @r_posters = []
    @reacted_stories.group_by(&:poster_id).each do |r|
      @r_posters.push(r[0])
    end
    @r_posters.uniq!
    @r_users = User.where(id: @r_posters).group_by(&:id)
  end
  
  def set_bookmarked_stories
    @bookmarked_stories = []
    @user.bookmarks.includes(:story).each do |bookmark|
      if bookmark.story.active?
        unless bookmark.story.author_id == @user.id
          @bookmarked_stories.push(bookmark.story)
        end
      end
    end
    @bookmarked_stories.uniq!
  end
  
  def set_bookmark_posters
    @b_posters = []
    @bookmarked_stories.group_by(&:poster_id).each do |b|
      @b_posters.push(b[0])
    end
    @b_posters.uniq!
    @b_users = User.where(id: @b_posters).group_by(&:id)
#    @bookmarked_stories = Story.active.where.not(author_id: @user.id).joins(:bookmarks).where(:bookmarks => { :user_id => @user.id})
  end
  
  def set_commented_stories
    @commented_stories = []
    @user.comments.includes(:story).each do |comment|
      if comment.story.active?
        unless comment.story.author_id == @user.id
          @commented_stories.push(comment.story)
        end
      end
    end
    @commented_stories.uniq!
#    @commented_stories = Story.active.joins(:comments).where(:comments => { :user_id => @user.id, :deleted_at => nil})
  end
  
  def set_commented_story_posters
    @c_posters = []
    @commented_stories.group_by(&:poster_id).each do |c|
      @c_posters.push(c[0])
    end
    @c_posters.uniq!
    @c_users = User.where(id: @c_posters).group_by(&:id)
#    @bookmarked_stories = Story.active.where.not(author_id: @user.id).joins(:bookmarks).where(:bookmarks => { :user_id => @user.id})
  end
  
  def set_followers
    @followers = []
    @user.followers.each do |follower|
      if follower.not_deactive?
        @followers.push(follower)
      end
    end
    @followers.uniq!
#    @followers = Following.follower_active.where(user_id: @user.id)
  end
  
  def set_followings
    @followings = Following.following_active.where(follower_id: @user.id)
  end
  def set_followings_users
    @f_ids = []
    @followings_users = []
    @followings.each do |following|
      @f_ids.push(following.user_id)
    end
    @f_ids.uniq!
    @followings_users = User.where(id: @f_ids)
  end
  
  def set_tags
    @tags = Tag.all.group_by(&:name)
  end
  
  def set_anonymous_user
    @anonymous_user = User.where(anonymous: true).first
  end
end