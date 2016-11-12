class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def mark_as_read
    @user = current_user
    @notification = Notification.find(params[:id])
    @notification.update read: true
    respond_to do |format|
      if @notification.update(notification_params)
        format.html {redirect_to notifications_dashboard_path(@user) }
        format.js {render :partial => 'dashboard/notifications/markasread', :data => @notification.to_json}
      end
    end
  end
  
  def mark_as_read_array
    @user = current_user
    @notification = Notification.find(params[:notification])
    type = 0
    @ids = 0
    if @notification.class == Array && @notification.length > 1
      @ids = []
      @notification.each do |n|
        n.update read: true
        @ids.push(n.id)
      end
      type = 1
    elsif @notification.class == Array 
      @notification[0].update read: true
      type = 1
      @ids = []
      @ids.push(@notification[0].id)
    else 
      @ids = @notification.id
      @notification.update read: true
    end
    respond_to do |format|
      if type == 1
        if @notification.last.update(notification_params)
          @notification = @notification[0]
          format.html {redirect_to notifications_dashboard_path(@user) }
          format.js {render :partial => 'dashboard/notifications/markasread', :data => @notification.to_json, :locals => {ids: @ids.to_json.gsub(",", ", ")}}
        end
      else
        if @notification.update(notification_params)
          format.html {redirect_to notifications_dashboard_path(@user) }
          format.js {render :partial => 'dashboard/notifications/markasread', :data => @notification.to_json, :locals => {ids: @ids.to_json}}
        end
      end
    end
  end
  
  def mark_all_as_read
    @user = current_user
    @unread_notifications = Notification.where(user_id: @user.id, read: false)
    @unread_notifications.each do |notification|
      notification.update read: true
    end
    if @unread_notifications.last.update(notification_params)
      redirect_to notifications_dashboard_path(@user)
    end
  end
  
  private
  
  def notification_params
    params.permit(:read)
  end
end
