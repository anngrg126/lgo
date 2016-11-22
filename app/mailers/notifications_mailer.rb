class NotificationsMailer < ApplicationMailer
  default from: 'hello@letsgifton.com'
  
  def notifications_email(user)
    @user = user
    email_with_name = %("#{@user.full_name}" ,#{@user.email}>)
    @new_notifications = Notification.where(user_id: @user.id, read: false, updated_at: (Time.now - 24.hours)..Time.now)
    
    if @new_notifications.count > 0
      @notifiers = []
      @new_notifications.each do |n|
        @notifiers.push(User.find(n.notified_by_user_id).first_name)
      end
      @notifiers.uniq!
      if @notifiers.count > 3
        mail(
          to: email_with_name,
          subject: '#{@new_notifications.count} new notifications from #{@notifiers.first(3).join(", ")}, and #{@notifiers.count-3} more'
          )
      else
        mail(
          to: email_with_name,
          subject: '#{@new_notifications.count} new notifications from #{@notifiers.to_sentence}'
          )
      end
    end
  end
end
