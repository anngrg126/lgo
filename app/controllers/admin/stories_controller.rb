class Admin::StoriesController < ApplicationController
#  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_admin
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  
  def index
    @stories = Story.unpublished.active
  end
  
  def show
  end
  
  def edit
    if @story.classifications.empty?
      @story.classifications.build
    end
    @relationship_tags = Tag.where(tag_category: 1).map{|t| [t.name, t.id]}
    @occasion_tags = Tag.where(tag_category: 2).map{|t| [t.name, t.id]}
  end
  
  def destroy
    if @story.destroy
      destroy_notification(@story)
      flash[:success] = "Story has been deleted"
      redirect_to admin_stories_path
    end
  end
  
  def update
    @story.validate_final_fields = true
    @story.validate_main_image = true
    @story.admin_id = current_user[:id]
    unless @story.published? 
      @story.published = true
      @story.admin_published_at = DateTime.current
    end
    unless @story.anonymous?
      @story.poster_id = @story.author_id
    else
      @story.poster_id = 3
    end
    @story.last_user_to_update = "Admin"
    respond_to do |format|
      if @story.update(story_params)
        create_notification(@story)
        flash[:success] = "Story has been updated"
        format.html {redirect_to admin_story_path(@story)}
      else
        flash.now[:alert] = "Story has not been updated"
        format.html {render :edit}
        format.js {render :partial => 'admin/stories/storyerrors', :data => @story.to_json }
      end
    end
  end
  
  private
  def story_params
    params.require(:story).permit(:final_title, :final_body, :published, :admin_published_at, :main_image, classifications_attributes: [:id, :story_id, :tag_id, :primary])
  end
  
  def require_admin
    unless current_user && current_user.admin?
      redirect_to root_path
      flash[:alert] = "Error."
    end
  end
  
  def set_story
    @story = Story.find(params[:id])
  end
  
  def create_notification(story)
    ##update this so that notification only sent out if the published attribute changed!!!!
    
    #Notification to story author
    Notification.create(user_id: story.author_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 1,
                        read: false,
#                        origin_id: story.id,
                        story_id: story.id)
    #Notification for all people who follow the poster
    followings = Following.where(user_id: story.poster_id)
    followings.each do |follower|
      Notification.create(user_id: follower.follower_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 1,
                        read: false,
#                        origin_id: story.id,
                        options: "followers",
                        story_id: story.id)
    end
  end
  def destroy_notification(story)
    unless Notification.where(story_id: story.id).empty?
      Notification.where(story_id: story.id).each(&:destroy)                
    end
  end
end