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
  before_action :set_followers_users, only:  [:followers]
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
    @user = User.includes(:stories).friendly.find(params[:id])
    if @user == current_user
      @user = User.includes(:stories, :followers, :followings, :notifications).friendly.find(params[:id])
      #note: can make more efficient by also including reactions, and moving set_reacted_stories to a nested route in def show. Same for bookmarks.
    else
      @user = User.includes(:stories, :followers, :followings).friendly.find(params[:id])
    end
  end
  
  def set_authored_stories
    @authored_stories = @user.stories.select {|s| s.active?}
    @authored_stories.uniq!
  end
  
  def set_posted_stories
    unless @user == current_user
      @posted_stories = @user.stories_posted.select {|s| s.active? && s.published?}
    else
      @posted_stories = @user.stories.select {|s| s.active?  && s.published?}
    end
    @posted_stories.uniq!
  end
  
  def set_notifications
    @notifications = @user.notifications
    
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
    @reacted_stories = Set.new []
    @user_reactions = @user.reactions.includes(:story).select {|r| r.story.active? }
    if @user == current_user
      @user_reactions.each do |reaction|
        unless reaction.story.author_id == @user.id
          @reacted_stories.add(reaction.story)
        end
      end
    else
      @user_reactions.each do |reaction|
          @reacted_stories.add(reaction.story)
      end
    end
    # @reacted_stories.uniq!
  end
  
  def set_reaction_posters
    @r_posters = Set.new []
    @reacted_stories.each do |r|
      @r_posters.add(r.poster_user)
    end
    # @r_posters.uniq!
  end
  
  def set_bookmarked_stories
    @bookmarked_stories = []
    # @bookmarked_stories = @user.bookmarks.includes(:story).select{|b| b.story.active?}
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
    @b_users = Set.new []
    @bookmarked_stories.each do |b|
      @b_users.add(b.poster_user)
    end
    # @b_users.uniq!
    # @b_users = User.where(id: @b_posters).group_by(&:id)
  end
  
  def set_commented_stories
    @commented_stories = Set.new []
    @user.comments.includes(:story).each do |comment|
      if comment.story.active?
        unless comment.story.author_id == @user.id
          @commented_stories.add(comment.story)
        end
      end
    end
#    @commented_stories = Story.active.joins(:comments).where(:comments => { :user_id => @user.id, :deleted_at => nil})
  end
  
  def set_commented_story_posters
    @c_users = Set.new []
    @commented_stories.each do |c|
      @c_users.add(c.poster_user)
    end
    # @c_posters.uniq!
    # @c_users = User.where(id: @c_posters).group_by(&:id)
#    @bookmarked_stories = Story.active.where.not(author_id: @user.id).joins(:bookmarks).where(:bookmarks => { :user_id => @user.id})
  end
  
  def set_followers
    @followers = @user.followers.select {|f| f.user.not_deactive?}
  end
  
  def set_followers_users
    @followers_users = []
    @followers.each do |follower|
      @followers_users.push(follower.follower)
    end
    @followers_users.uniq!
  end
  
  def set_followings
    @followings = @user.followings.select{|f| f.user.deactivated_at==nil}
  end
  
  def set_followings_users
    @followings_users = []
    @followings.each do |following|
      @followings_users.push(following.user)
    end
    @followings_users.uniq!
  end
  
  def set_tags
    @tags = Tag.alltags
  end
  
  def set_anonymous_user
    @anonymous_user = User.where(anonymous: true).first
  end
end