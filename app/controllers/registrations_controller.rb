class RegistrationsController < Devise::RegistrationsController
  before_action :redirect_cancel, :only => [:update]

  def new 
    super
  end

  def create
    super
  end

  def edit
    form_render = params[:form_render]
    respond_to do |format|
      unless form_render == ""
        if form_render == "user_password" || form_render == "user_email"
          format.html {render 'devise/registrations/edit', locals: {form_render: form_render}}
        else
          format.js {render :partial => 'devise/registrations/edit.js.erb', locals: {form_render: form_render}}
        end
      end
    end
  end
  
  def update
    if params[:user]
      params[:user][:status] = 'active_db'
    end
    verify_password = params[:with_password]
    respond_to do |format|
      unless verify_password == "true"
        if resource.update_without_password(account_update_params)
          flash[:success] = "Profile has been updated"
          format.html { redirect_to dashboard_path(resource) }
        else
          flash.now[:warning] = "Profile has not been updated"
          format.js {render :partial => 'dashboard/registrations/usererrors', :data => resource.to_json  }
        end
      else
        if resource.update_with_password(account_update_params)
          flash[:success] = "Profile has been updated"
          sign_in(@user, bypass: true)
          format.html { redirect_to dashboard_path(resource) }
        else
          flash.now[:warning] = "Profile has not been updated"
          format.html {render :edit, locals: {form_render: params[:form_render]}}
        end
      end
    end
  end
  
  def destroy
    @user.deactivated_at = DateTime.now
    if @user.save
      destroy_notifications(@user)
      deactivate_stories(@user)
      deactivate_comments(@user)
      flash[:success] = "Account has been deactivated"
      sign_out @user
      redirect_to new_user_session_path
    end
  end

  protected
  
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
  
  def after_sign_up_path_for(resource)
    @user = current_user
    flash[:notice] = nil
    registration_step_path(:basic_details)
  end
  
  private
  
  def account_update_params
    if params[:user]
      params.require(:user).permit(:first_name, :last_name, :about_me, :status, :birthday, :gender, :image, :fbimage, :password, :password_confirmation, :current_password, :email)
    else
      params.permit(:image)
    end
  end
  
  def redirect_cancel
    redirect_to dashboard_path(resource) if params[:cancel]
  end
  
  def destroy_notifications(user)
      Notification.where(user_id: user.id).each(&:destroy)  
  end
  
  def deactivate_stories(user)
    Story.active.where(:author_id => user.id).update_all("author_deactive = true")
    # @stories = Story.active.where(author_id: user.id)
    # @stories.each do |story|
    #   story.update(deactivated: true)
    # end
  end
  
  def deactivate_comments(user)
    Comment.active.where(:user_id => user.id).update_all("author_deactive = true") 
    # @comments = Comment.active.where(user_id: user.id)
    # @comments.each do |comment|
    #   comment.update(deactivated: true)
    # end
  end
  
  
end