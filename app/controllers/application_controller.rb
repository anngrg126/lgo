class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  
  def after_sign_in_path_for(resource)
#    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    @user = current_user
    if @user.deactivated_at != nil
      @user.deactivated_at = nil
      @user.save
      activate_stories(@user)
      activate_comments(@user)
    end
    super resource   
  end
  
  def activate_stories(user)
    Story.active.where(:author_id => user.id).update_all("author_deactive = false")
    # @stories = Story.active.where(author_id: user.id)
    # @stories.each do |story|
    #   story.update(deactivated: false)
    # end
  end
  
  def activate_comments(user)
    Comment.active.where(:user_id => user.id).update_all("author_deactive = false")
    # @comments = Comment.active.where(user_id: user.id)
    # @comments.each do |comment|
    #   comment.update(deactivated: false)
    # end
  end
end
