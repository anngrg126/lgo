class FollowingsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    unless current_user
      flash[:warning] = "Please sign in to continue"
      redirect_to new_user_session_path
    else 
      @following = Following.create(following_params)
      if @following.save
        create_notification @following
        respond_to do |format|
          @user = @following.user
          flash.now[:success] = "You are now following #{@user.full_name}"
          format.js {render 'followings/create', :locals => {followings: User.joins(:followings).where(:followings => { follower_id: current_user.id}).select{ |f| f.deactivated_at==nil }.length}}
        end
#        format.html {redirect_to root_path}
      else
        flash[:warning] = "#{@following.user.full_name} could not be followed"
        redirect_to dashboard_path(@user)
      end
    end
  end
  
  def destroy
    @following = Following.find(params[:id])
    if @following.destroy
      destroy_notification(@following)
      respond_to do |format|
        @user = @following.user
        flash.now[:success] = "You unfollowed #{@user.full_name}"
        format.js {render 'followings/destroy', :locals => {followings: User.joins(:followings).where(:followings => { follower_id: current_user.id}).select{ |f| f.deactivated_at==nil }.length}}
      end
#      redirect_to dashboard_path(@user)
    else
      flash[:danger] = "#{@following.user.full_name} could not be unfollowed"
      redirect_to dashboard_path(@user)
    end
  end
  
  private
  
  def following_params
    params.permit(:follower_id, :user_id) 
  end
  
  def create_notification(following)
    Notification.create(user_id: following.user.id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 5,
                        read: false,
                        origin_id: following.id)
  end
  def destroy_notification(following)
    unless Notification.where(notification_category_id: 5,
                       origin_id: following.id).empty?
      Notification.where(notification_category_id: 5,
                       origin_id: following.id).destroy_all
    end
  end
end