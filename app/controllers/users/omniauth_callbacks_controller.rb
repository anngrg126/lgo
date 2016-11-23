class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      # if @user is a new record
#      sign_in_and_redirect @user #this will throw if @user is not activated
      sign_in @user
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      redirect_to dashboard_path(@user)
      create_subscription(user)
    else
      # if @user is NOT a new record
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    end
  end

  def failure
    redirect_to root_path, alert: "Login failed"
  end
  
  private
  
  def create_subscription(user)
    if SubscriptionPreference.where(user_id: user.id).empty?
      SubscriptionPreference.create(user_id: user.id)
    end
  end
end