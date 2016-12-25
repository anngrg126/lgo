module ApplicationHelper
#  def signed_in_user
#    unless current_page? registration_step_path(:basic_details)
#      html = <<-HTML
#<div class="navbar-text">Signed in as #{current_user.email}.</div>
#HTML
#      html.html_safe
#    end
#  end
#  
  def user_notifications_link
    unless current_user
      link_to "My Notifications", new_user_session_path, class: "hide-for-small-only inactive-link"
    else
      unless Notification.where(user_id: current_user.id, read: false).count == 0
        link_to "Notifications: #{Notification.where(user_id: current_user.id, read: false).count}", notifications_dashboard_path(current_user)
      end
    end
  end
  
end
