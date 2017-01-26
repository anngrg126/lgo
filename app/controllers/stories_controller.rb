class StoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_story, only: [:edit, :update, :destroy, :check_for_cancel]
  before_action :redirect_cancel, :only => [:update]
  before_action :set_tags, only: [:show, :index, :new, :edit]
  
  def index
    @active_browse = "active"
    @anonymous_user = User.where(anonymous: true).first
    if params[:search]
      @results = (Story.includes(:user, :classifications).search params[:search], operator: "or")
      @stories = @results.results
      log_search_query(params[:search], @results.count)
      if @results.count <=0
        flash[:warning] = "No stories matched : "+ params[:search]
        redirect_to root_path
      end
    elsif params[:search_tag]
      @results = (Story.includes(:user, :classifications).search params[:search_tag], fields: [tags: :exact])
      @stories = @results.results
      if @results.count <=0
        flash[:warning] = "No records matched : "+ params[:search_tag]
        redirect_to root_path
      end
    else
      @stories = Story.includes(:user, :classifications).published.active
    end
  end
  
  def new
    @active_share = "active"
    @story = Story.new
    @story.pictures.build(:image => params[:image])   
  end
  
  def create
    @story = current_user.stories.build(story_params)
    @story.published = false
    @story.author_id = current_user[:id]
    respond_to do |format|
      if params[:image]
        params[:image].each { |image|
          @picture = @story.pictures.build(image: image)
        }
      end
      if @picture.nil? || !@picture.errors.any?
        if @story.save
          flash[:success] = "Story has been submitted"
          format.html {redirect_to dashboard_path(current_user)}
          NotificationsMailer.admin_story_email(@story).deliver_now
        end
      end
      unless @story.save
        flash.now[:alert] = "Story has not been submitted"
        format.html {render :new}
        format.js {render :partial => 'stories/storyerrors', :data => [ @story.to_json, @picture.to_json ] }
      end
    end
  end
  
  def show
    @anonymous_user = User.where(anonymous: true).first
    @story = Story.includes(:user, :classifications, :bookmarks, :reactions, :pictures).find(params[:id])
    @story_comments = @story.comments.includes(:user).select{|c| c.deleted_at == nil && c.author_deactive == false}
    @active_browse = "active"
    @comment = @story.comments.active.build
    @bookmark = @story.bookmarks.build
  end
  
  def edit
    if @story.user != current_user
      flash[:warning] = "You can only edit your own stories."
      redirect_to root_path
    end
  end
  
  def update
    if @story.published?
      @story.validate_updated_fields = true
      @story.assign_attributes(story_params)
      @notify_followers = false
      if @story.anonymous_changed?
        if @story.anonymous
#          @story.poster_id = User.where(anonymous: true).first.id
          @story.poster_id = @anonymous_user.id
          destroy_notification(@story)
          @notify_followers = true
        else
          @story.poster_id = @story.author_id
          destroy_notification(@story)
          @notify_followers = true
        end
      end
      if @story.fail_changed?
        @fail_tag = Tag.where(name: "fail").first
        if @story.fail?
          if @story.classifications.select{|c| c.tag_id == @fail_tag.id}.empty?
            @story.classifications.create(tag_id: @fail_tag.id, primary: false)
          end
        else
          unless @story.classifications.select{|c| c.tag_id == @fail_tag.id}.empty?
            @story.classifications.select{|c| c.tag_id == @fail_tag.id}.each(&:destroy)
          end
        end
      end
    else
      if @story.anonymous?
        @story.poster_id = nil
      end
    end
    @story.last_user_to_update = "Author"
    respond_to do |format|
      if @story.user != current_user
        flash[:warning] = "You can only edit your own stories."
        redirect_to root_path
      else
        if @story.update(story_params)
          flash[:success] = "Story has been updated"
          format.html {redirect_to story_path(@story)}
          if @notify_followers == true
            create_notification(@story)
          end
          notify_admin(@story)
        else
          flash.now[:alert] = "Story has not been updated"
          format.html {render :edit} #renders edit tmplt again
          format.js {render :partial => 'stories/storyerrors', :data => @story.to_json }
        end
      end
    end
  end
  
  def destroy
    @story.deleted_at = DateTime.now
    if @story.save
      destroy_notification(@story)
      flash[:success] = "Story has been deleted"
      redirect_to stories_path
    end
  end
  
  private
  
  def story_params
    params.require(:story).permit(:raw_title, :raw_body, :raw_gift_description, :updated_title, :updated_body, :updated_gift_description, :anonymous, :fail, :review, pictures_attributes: [:id, :story_id, :_destroy, :image])
  end
  
  def set_story
    @story = Story.includes(:user, :classifications).find(params[:id])
    #to make sure users can only get to their own stories
    #@story = current_user.stories.find(params[:id]) #This first grabs the user, then grabs their stories, starts with a smaller scope than all stories
    @anonymous_user = User.where(anonymous: true).first
  end
  
  def redirect_cancel
    redirect_to story_path(@story) if params[:cancel]
  end
  
  def create_notification(story)
    #Notification for all people who follow the poster
    followings = Following.where(user_id: story.poster_id)
    followings.each do |follower|
      Notification.create(user_id: follower.follower_id,
                        notified_by_user_id: story.poster_id,
                        notification_category_id: 1,
                        read: false,
#                        origin_id: story.id,
                        options: "followers",
                        story_id: story.id)
    end
  end
  def notify_admin(story)
    Notification.create(user_id: story.admin_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 1,
                        read: false,
#                        origin_id: story.id,
                        options: "admin",
                        story_id: story.id)
  end
  def destroy_notification(story)
    unless Notification.where(story_id: story.id).empty?
      Notification.where(story_id: story.id).each(&:destroy)                
    end
  end
  
  def log_search_query(query_string, result_count)
    if current_user
      user_id = current_user.id
    else
      user_id = nil
    end
    SearchQueryLog.create(query_string: query_string, result_count: result_count, user_id: user_id)
  end
    
  def set_tags
    @tags = Tag.alltags
  end
end