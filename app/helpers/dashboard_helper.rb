module DashboardHelper
  def user_photo(user)
    if user.image_file_name?
      image_tag user.image.url(:medium)
    elsif @user.fbimage?
      image_tag(user.largesquareimage)
    else
      if user == current_user
        link_to "Upload Photo", edit_user_dashboard_registration_path(user, form_render: "user_image"), remote: true
      end
    end
  end
  
  def edit_user_name(user)
    if user == current_user
      link_to "Edit", edit_user_dashboard_registration_path(@user, form_render: "user_name"), remote: true
    end
  end
  
  def edit_user_photo(user)
    if user == current_user
      link_to "Edit", edit_user_dashboard_registration_path(@user, form_render: "user_image"), remote: true
    end
  end
  
  def edit_user_about_me(user)
    if user == current_user
      if user.about_me.empty?
        link_to "Add an about me", edit_user_dashboard_registration_path(@user, form_render: "user_about_me"), remote: true
      else
        link_to "Edit", edit_user_dashboard_registration_path(@user, form_render: "user_about_me"), remote: true
      end
    end
  end
  
  def user_about_me(user)
    unless user.about_me.blank?
      body = "<div'>About Me</div><div>#{user.about_me}</div>".html_safe
    else
      if user == current_user
        body = "<div>About Me</div>".html_safe
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
  
  def user_reaction(story, user)
    output = [""]
    Reaction.where(story_id: story.id, user_id: user.id).each do |reaction|
      output.push(content_tag(:span) {
        case reaction.reaction_category_id
        when 1
          concat "Like".html_safe
        when 2
          concat "OMG".html_safe
        when 3
          concat "LOL".html_safe
        when 4
          concat "Cool".html_safe
        when 5
          concat "Love".html_safe
        end
        })
    end
    return output.join(" ")
  end
end