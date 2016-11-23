class CommentsController < ApplicationController
  before_action :set_story
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :redirect_cancel, :only => [:update]
  
  def index
    @comment = @story.comments.active
  end
  
  def create
    unless current_user
      flash[:warning] = "Please sign in to continue"
      redirect_to new_user_session_path
    else
      @comment = @story.comments.active.build(comment_params)
      @comment.user = current_user    
      respond_to do |format|
        if @comment.save
          create_notification(@comment)
          flash[:success] = "Comment has been added"
          format.html { redirect_to story_path(@story) }
        else
          flash.now[:warning] = "Comment has not been added"
          format.js {render :partial => 'comments/commenterrors', :data => @comment.to_json }
        end
      end
    end
  end
  
  def edit
    if @comment.user != current_user
      flash[:alert] = "You can only edit your own comments"
      redirect_to story_path(@story)
    end   
    respond_to do |format|
      format.js
    end
  end
  
  def update
    if @comment.user != current_user
      flash[:alert] = "You can only edit your own comments"
      redirect_to story_path(@story)
    else
      respond_to do |format|
        if @comment.update(comment_params)
          flash[:success] = "Comment has been updated"
          format.html {redirect_to story_path(@story)}
        else
          flash.now[:warning] = "Comment has not been updated"
          format.js {render :partial => 'comments/commenterrors', :data => @comment.to_json }
        end
      end
    end
  end
  
  def destroy
    if @comment.user != current_user
      flash[:alert] = "You can only edit your own comments"
      redirect_to story_path(@story)
    else
      @comment.deleted_at = DateTime.now
      if @comment.save
        destroy_notification(@comment)
        flash[:success] = "Comment has been deleted"
        redirect_to story_path(@story)
      end
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def set_story
    @story = Story.find(params[:story_id])#if just :id, it's comment id
  end
    
  def set_comment
    @comment = @story.comments.find(params[:id])
  end
  
  def redirect_cancel
    redirect_to story_path(@story) if params[:cancel]
  end
  
  def create_notification(comment)
    story = Story.find(comment.story_id)
    unless current_user.id == story.author_id
      #story author gets notification
      Notification.create(user_id: User.find(story.author_id).id,
                          notified_by_user_id: current_user.id,
                          notification_category_id: 2,
                          read: false,
                          origin_id: comment.id,
                          story_id: story.id)
    end
    #get array of id's of other users who commented
    user_array = []
    Story.find(comment.story_id).comments.active.each do |existingcomment|
      unless comment.user_id == existingcomment.user_id || existingcomment.user_id == story.author_id
        user_array.push(existingcomment.user_id)
      end
    end
    user_array.uniq
    user_array.each do |existingcomment_userid|
      #others who commented get a notification
      unless User.find(existingcomment_userid).id == current_user.id
        Notification.create(user_id: User.find(existingcomment_userid).id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 2,
                        read: false,
                        origin_id: comment.id,
                        options: "commenters",
                        story_id: story.id)
      end
    end
  end
  
  def destroy_notification(comment)
    unless Notification.where(notification_category_id: 2,
                       origin_id: comment.id).empty?
      Notification.where(notification_category_id: 2,
                       origin_id: comment.id).each(&:destroy)
    end
  end
end
