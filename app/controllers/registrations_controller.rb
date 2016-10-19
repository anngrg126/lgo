class RegistrationsController < Devise::RegistrationsController
  
  include Wicked::Wizard
  
  steps :basic_details, :basic_details2
  
  def new 
    super
  end

  def create
    super
  end

  def update 
    super
  end

  def edit
    respond_to do |format|
      format.js
    end
  end
  
  def update
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
  
#  def after_sign_up_path_for(resource)
#    after_signup_path(:create_profile)
#  end  
  def after_sign_up_path_for(resource)
    registration_steps_path
  end
  
  private
  
  def account_update_params
    params[:user].permit(:first_name, :last_name, :about_me)
  end
  
end