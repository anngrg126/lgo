# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview
  def daily_email
    NotificationsMailer.daily_email(User.find(176))
  end
  
  #preview:  http://localhost:3000/rails/mailers/notifications_mailer/daily_email
  
  def admin_story_email
    NotificationsMailer.admin_story_email(Story.first)
  end
  
  #preview:  http://localhost:3000/rails/mailers/notifications_mailer/admin_story_email
end

