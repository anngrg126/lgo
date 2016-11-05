module DashboardHelper
  def user_photo(user)
    if @user == current_user
      if @user.image_file_name?
        image_tag @user.image.url(:medium)
      elsif @user.fbimage?
        image_tag(@user.largesquareimage)
      else
        link_to "Upload Photo", edit_user_dashboard_registration_path(@user), remote: true
        end
    end
  end
  
  def story_main_image(story)
    unless story.main_image_file_name.nil?
      image_tag story.main_image.url
    end
  end
  
  def story_title(story)
    if story.published?
      if story.last_user_to_update == "Admin"
        body = story.final_title
      else
        body = story.updated_title
      end
    else
      body = story.raw_title
    end
  end
  
  def story_body(story)
    if story.published?
      if story.last_user_to_update == "Admin"
        body = story.final_body
      else
        body = story.updated_body
      end
    else
      body = story.raw_body
    end
    if body.nil?
      body = "PROBLEM"
    else
      truncate_body_list(body)
    end
  end
  
  def story_pending(story)
    unless story.published?
      html = "<div>Pending</div>".html_safe
    end
  end
  
  def story_anonymous(story)
    if story.anonymous?
      html = "<div>Anonymous</div>".html_safe
    end
  end
  
  def story_by(story)
    if story.poster_id?
      html = "<div>Posted by: #{User.find(story.poster_id).full_name}</div>".html_safe
    else
      html = "<div>Written by: #{User.find(story.author_id).full_name}</div>".html_safe
    end
  end
end