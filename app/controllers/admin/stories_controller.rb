class Admin::StoriesController < ApplicationController
#  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_admin
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  
  def index
    @stories = Story.unpublished
  end
  
  def show
  end
  
  def edit
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
        create_notification @story
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
    params.require(:story).permit(:final_title, :final_body, :published, :admin_published_at, :main_image)
  end
  
  def require_admin
    unless current_user.admin?
      redirect_to root_path
      flash[:alert] = "Error."
    end
  end
  
  def set_story
    @story = Story.find(params[:id])
  end
  
  def create_notification(story)
    Notification.create(user_id: story.author_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 1,
                        read: false,
                        origin_id: story.id)
  end
  def destroy_notification(story)
    unless Notification.where(notification_category_id: 1,
                       origin_id: story.id).empty?
      Notification.where(notification_category_id: 1,
                       origin_id: story.id).first.destroy
    end
  end
end