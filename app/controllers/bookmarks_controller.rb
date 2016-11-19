class BookmarksController < ApplicationController
  before_action :set_story
  
  def create
    unless current_user
      flash[:warning] = "Please sign in to continue"
      redirect_to new_user_session_path
    else
      @bookmark = @story.bookmarks.build(bookmarks_params)
      @bookmark.user = current_user
      respond_to do |format|
        if @bookmark.save
          create_notification(@bookmark)
          flash.now[:success] = "Story has been saved"
          format.js {render :partial => 'bookmarks/showbookmarks'}
          format.html {redirect_to story_path(@story)}
        else
          flash[:warning] = "Save has not been added"
          format.html { redirect_to story_path(@story)}
        end
      end
    end
  end
  
  def destroy
    @bookmark = @story.bookmarks.find_by(user_id: current_user)
    respond_to do |format|
      if @bookmark.destroy
        destroy_notification(@bookmark)
        flash.now[:success] = "Story save has been deleted"
        format.js {render :partial => 'bookmarks/showbookmarks'}
#        redirect_to story_path(@story)
      end
    end
  end
  
  private
  
  def bookmarks_params
#    params.require(:story_like).permit(:user_id, :story_id) #Q:Do i need to whitelist this? It throws an error.
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