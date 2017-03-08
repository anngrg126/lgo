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
    log_user_sign_in(@user)
    super resource
    dashboard_path(@user)
  end
  
  def activate_stories(user)
    Story.active.where(:author_id => user.id).update_all("author_deactive = false")
  end
  
  def activate_comments(user)
    Comment.active.where(:user_id => user.id).update_all("author_deactive = false")
  end
  
  def log_user_sign_in(resource)
    UserSessionLog.log(resource, "sign_in")
  end
  
  def require_complete_user
    if current_user
      if current_user.first_name == nil || current_user.last_name == nil
        redirect_to registration_step_path(:basic_details)
      end
    end
  end
end
