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
      @current_user_notifications_header = current_user.notifications.select{ |n| n.read == false}.length
      unless @current_user_notifications_header == 0
        link_to notifications_dashboard_path(current_user) do
          concat "My Notifications ".html_safe
          concat "<span class='notifications_count'>(#{@current_user_notifications_header})</span>".html_safe
        end
      end
    end
  end
  def user_notifications_link_small
    if current_user
      @current_user_notifications_header = current_user.notifications.select{ |n| n.read == false}.length
      unless @current_user_notifications_header == 0
        link_to notifications_dashboard_path(current_user) do
          concat "<span class='notifications_count'>(#{@current_user_notifications_header})</span>".html_safe
        end
      end
    end
  end
  
end