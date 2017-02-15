module DashboardHelper
  def user_photo(user)
    if user.image_file_name?
      image_tag(user.image.url(:medium))
    elsif user.fbimage?
      image_tag(user.largesquareimage)
    else
      image_tag('default_user_image.png')
    end
  end
  
  def user_photo_path(user)
    if user.image_file_name?
      image_path(user.image.url(:medium))
    elsif user.fbimage?
      image_path(user.largesquareimage)
    else
      image_path('default_user_image.png')
    end
  end
  
  def edit_user_name(user)
#    if user == current_user
#      link_to "Edit", edit_user_dashboard_registration_path(user, form_render: "user_name"), remote: true
#    end
  end
  
  def edit_user_photo(user)
    if user == current_user
      unless user.image_file_name? || user.fbimage?
        link_to "Upload Photo", edit_user_dashboard_registration_path(user, form_render: "user_image"), class: "primary-link", remote: true
      else
        link_to "Edit", edit_user_dashboard_registration_path(user, form_render: "user_image"), class: "primary-link", remote: true
      end
    end
  end
  
  def edit_user_about_me(user)
    if user == current_user
      if user.about_me == nil || user.about_me == ""
        link_to edit_user_dashboard_registration_path(user, form_render: "user_about_me"), class: "primary-link", remote: true do
          content_tag(:span, "Introduce yourself here ") +
          content_tag(:span, "", class: "fa fa-pencil")
        end
      else
#        link_to "Edit", edit_user_dashboard_registration_path(user, form_render: "user_about_me"), remote: true
        link_to edit_user_dashboard_registration_path(user, form_render: "user_about_me"), class: "small-icon-button secondary-icon", remote: true do
          content_tag(:span, "", class: "fa fa-pencil")
        end
      end
    end
  end
  
  def user_about_me(user)
    unless user.about_me.blank?
      body = user.about_me
    end
  end
  
  def user_about_me_title(user)
    if !user.about_me.blank? || current_user == user
      content_tag(:strong, "About Me")
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
      unless story.raw_title == ""
        body = story.raw_title
      else
        body = "My Story"
      end
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
  
#  def story_pending(story)
#    unless story.published?
#      html = "Pending".html_safe
#    end
#  end
  
  def story_anonymous(story)
    if story.anonymous?
      content_tag(:div, "Anonymous (only you can see this story on your dashboard", class: "subtext")
#      html = "<div>Anonymous (only you can see this story on your dashboard)</div>".html_safe
    end
  end
  
  def story_by(story)
    if story.poster_id?
#      html = "<div>Posted by: #{User.find(story.poster_id).full_name}</div>".html_safe
      unless story.anonymous
        html = "<div>Posted by: #{story.user.full_name}</div>".html_safe
      else
        html = "<div>Posted by: #{@anonymous_user.full_name}</div>".html_safe
      end
    else
      html = "<div>Written by: #{story.user.full_name}</div>".html_safe
    end
  end
  
  def user_reaction(story, user)
    output = [""]
#    Reaction.where(story_id: story.id, user_id: user.id).each do |reaction|
    @user.reactions.group_by(&:story_id).select{|story_id| story_id == story.id}.first[1].each do |reaction|
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