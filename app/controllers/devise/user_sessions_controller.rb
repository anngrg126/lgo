class Devise::UserSessionsController < Devise::SessionsController
  before_action :set_tags, only: [:show, :index, :new, :edit]

  def destroy
    if current_user
      if UserSessionLog.where(user_id: current_user.id).any?
        @user = current_user
        log_user_sign_out(@user)
        super
      else
        super
      end
    else
      super
    end
  end

  def log_user_sign_out(resource)
      UserSessionLog.log(resource, "sign_out")
  end

  private
  def set_tags
    @tags = Tag.alltags
  end

end