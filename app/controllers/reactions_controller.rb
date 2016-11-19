class ReactionsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @reaction = Reaction.create(reaction_params)
    if @reaction.save
      respond_to do |format|
        create_notification(@reaction)
        @story = Story.find(@reaction.story_id)
        format.js {render :data => [ @reaction.to_json, @story.to_json] }
      end
    else
      flash[:warning] = "Your reaction could not be recorded."
      redirect_to story_path(Story.find(@reaction.story_id))
    end
  end
  
  def destroy
    @reaction = Reaction.find(params[:id])
    @story = Story.find(@reaction.story_id)
    respond_to do |format|
      if @reaction.destroy
        destroy_notification(@reaction)
        format.js {render :data => @reaction.to_json }
      else
        flash[:danger] = "Your reaction could not be removed."
        redirect_to story_path(Story.find(@reaction.story_id))
      end
    end
  end
  
  private
  
  def reaction_params
    params.permit(:story_id, :user_id, :reaction_category_id) 
  end
  
  def create_notification(reaction)
    #Notification to story author
    story = Story.find(reaction.story_id)
    unless current_user.id == story.author_id
      Notification.create(user_id: story.author_id,
                          notified_by_user_id: current_user.id,
                          notification_category_id: 3,
                          read: false,
                          origin_id: reaction.id,
                          options: reaction.reaction_category_id.to_s,
                          story_id: story.id)
    end
  end
  def destroy_notification(reaction)
    unless Notification.where(notification_category_id: 3,
                       origin_id: reaction.id).empty?
      Notification.where(notification_category_id: 3,
                       origin_id: reaction.id).each(&:destroy)
    end
  end
end