class RegistrationsController < Devise::RegistrationsController
  before_action :redirect_cancel, :only => [:update]

  def new 
    super
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
    create_subscription(resource)
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
  
  def create_subscription(user)
    if SubscriptionPreference.where(user_id: user.id).empty?
      SubscriptionPreference.create(user_id: user.id)
    end
  end
end