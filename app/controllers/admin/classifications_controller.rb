class Admin::ClassificationsController < ApplicationController
  before_action :require_admin
  before_action :set_story
  
  def destroy
    @classification = Classification.find(params[:id])
    @story = Story.find(@classification.story_id)
    if @classification.destroy
      redirect_to admin_story_path(@story)
    end
  end
  
  private 
  
  def set_story
    @story = Story.find(params[:story_id])
  end
  
  def require_admin
    unless current_user && current_user.admin?
      redirect_to root_path
      flash[:alert] = "Error."
    end
  end
end