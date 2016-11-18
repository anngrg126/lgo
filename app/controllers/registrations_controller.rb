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
#        format.js
        format.js {render :partial => 'devise/registrations/edit.js.erb', locals: {form_render: form_render}}
      else
        format.html#TEST; remove in a second
      end
    end
  end
  
  def update
    @user = current_user
    params[:user][:status] = 'active_db'
    respond_to do |format|
      if resource.update_without_password(account_update_params)
        flash[:success] = "Profile has been updated"
        format.html { redirect_to dashboard_path(resource) }
      else
        flash.now[:warning] = "Profile has not been updated"
        format.js {render :partial => 'dashboard/registrations/usererrors', :data => resource.to_json  }
      end
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
    params[:user].permit(:first_name, :last_name, :about_me, :status, :birthday, :gender, :image, :fbimage)
  end
  
  def redirect_cancel
    redirect_to dashboard_path(resource) if params[:cancel]
  end
end