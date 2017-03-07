desc 'send digest email'
task send_digest_email: :environment do
  # ... set options if any
  @new_notifications = Notification.where(read: false, updated_at: (Time.now - 24.hours)..Time.now)
  @users = []

  @new_notifications.each do |n|
    @users.push(n.user_id)
  end

  @users.uniq!

  @users.each do |user|
    unless user == nil
      NotificationsMailer.daily_email(User.find(user)).deliver_now
    end
  end
end