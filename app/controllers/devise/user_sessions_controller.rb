class Devise::UserSessionsController < Devise::SessionsController

    before_action :set_tags, only: [:show, :index, :new, :edit]
    
    def destroy
        @user = current_user
        log_user_sign_out(@user)
        super
    end

    def log_user_sign_out(resource)
        UserSessionLog.log(resource, "sign_out")
    end
    
    private
    def set_tags
        @tags = Tag.all.group_by(&:name)
    end

end