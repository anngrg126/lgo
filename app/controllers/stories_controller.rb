class StoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_story, only: [:show, :edit, :update, :destroy, :check_for_cancel]
  before_action :redirect_cancel, :only => [:update]
  
  def index
    @stories = Story.published.where(deleted_at: nil)
  end
  
  def new
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
    @comment = @story.comments.build
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
      notify_admin(@story)
      if @story.anonymous_changed?
        if @story.anonymous
          @story.poster_id = 3
          destroy_notification(@story)
          create_notification(@story)
        else
          @story.poster_id = @story.author_id
          destroy_notification(@story)
          create_notification(@story)
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
    params.require(:story).permit(:raw_title, :raw_body, :updated_title, :updated_body, :anonymous, :review, pictures_attributes: [:id, :story_id, :_destroy, :image])
  end
  
  def set_story
    @story = Story.find(params[:id])
    #to make sure users can only get to their own stories
    #@story = current_user.stories.find(params[:id]) #This first grabs the user, then grabs their stories, starts with a smaller scope than all stories
  end
  
  def redirect_cancel
    redirect_to story_path(@story) if params[:cancel]
  end
  
  def create_notification(story)
    #Notification for all people who follow the poster
    followings = Following.where(user_id: story.poster_id)
    followings.each do |follower|
      Notification.create(user_id: follower.follower_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 1,
                        read: false,
                        origin_id: story.id,
                        options: "followers")
    end
  end
  def notify_admin(story)
    Notification.create(user_id: story.admin_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 1,
                        read: false,
                        origin_id: story.id,
                        options: "admin")
  end
  def destroy_notification(story)
    unless Notification.where(notification_category_id: 1,
                       origin_id: story.id).empty?
      Notification.where(notification_category_id: 1,
                       origin_id: story.id).each(&:destroy)
    end
  end
end