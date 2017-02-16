class BookmarksController < ApplicationController
  before_action :set_story
  before_action :authenticate_user!
  
  def create
    @bookmark = Bookmark.create(bookmark_params)
    if @bookmark.save
      respond_to do |format|
        create_notification(@bookmark)
        @story = Story.find(@bookmark.story_id)
        format.js {render :data => [ @bookmark.to_json, @story.to_json] }
      end
    else
      flash[:warning] = "Your bookmark could not be recorded."
      redirect_to story_path(@story)
    end
  end
  
  def destroy
    @bookmark = @story.bookmarks.find_by(user_id: current_user)
    respond_to do |format|
      if @bookmark.destroy
        destroy_notification(@bookmark)
        format.js {render :data => @story.to_json }
      else
        flash[:danger] = "Your bookmark could not be removed."
        redirect_to story_path(@story)
      end
    end
  end
  
  private
  
  def bookmark_params
    params.permit(:story_id, :user_id) 
    # params.require(:story_like).permit(:user_id, :story_id) #Q:Do i need to whitelist this? It throws an error.
  end
  
  def set_story
    @story = Story.find(params[:story_id])
  end
  
  def create_notification(bookmark)
    #Notification to story author
    story = Story.find(bookmark.story_id)
    unless current_user.id == story.author_id
      Notification.create(user_id: story.author_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 4,
                        read: false,
                        origin_id: bookmark.id,
                        story_id: story.id)
    end
  end
  def destroy_notification(bookmark)
    unless Notification.where(notification_category_id: 4,
                       origin_id: bookmark.id).empty?
      Notification.where(notification_category_id: 4,
                       origin_id: bookmark.id).each(&:destroy)
    end
  end
end