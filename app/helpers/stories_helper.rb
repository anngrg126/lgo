module StoriesHelper
  def story_main_image_show(story)
    unless story.main_image_file_name.nil?
      image_tag story.main_image.url
    end
  end
  
  def story_title_show(story)
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
  
  def story_body_show(story)
    if story.published?
      if story.last_user_to_update == "Admin"
        body = story.final_body
      else
        body = story.updated_body
      end
    else
      body = story.raw_body
    end
    html = "<div>#{body}</div>".html_safe
  end
  
  def story_by_show(story)
    if story.published?
      link = link_to "#{User.find(story.poster_id).full_name}", dashboard_path(User.find(story.poster_id))
      partial =  render partial: 'followings/form', locals: { user: User.find(story.poster_id), follower: current_user }
      html = "<div>Posted by: #{link}</div><div>#{partial}</div>".html_safe
     
    else
      if story.anonymous?
        html = "<div>Posted by: Anonymous</div>"
      else
        link = link_to "#{User.find(story.author_id).full_name}", dashboard_path(User.find(story.author_id))
        html = "<div>Posted by: #{link}".html_safe
      end
    end
  end
  
  def truncate_body_list(body)
    body.gsub!('<br>', ' ')
    body.gsub!('</li>', ' ')
    body.gsub!('<ol>', ' ')
    body.gsub!('<ul>', ' ')
    truncate(strip_tags("#{body}").gsub('&amp;','&'), length: 150)
  end
  
  def admin_tag_story(story, tag_scope_array)
    #consolidate relevant info that belongs to a story
    #this does not hit the DB b/c of the includes query
    #in the admin/stories_controller.rb
    @tag_array = []
    @primary_array = []
    @other_array = []
    story.classifications.each do |c|
      unless c.tag_id == nil
        @tag_array.push(c.tag_id)
      end
      if c.primary == true
        @primary_array.push(c.tag_id)
      end
      if c.description != nil
        @other_array.push([c.tag_id, c.description])
      end
    end
    def primary_tag(scope, tag, tag_name)
      if scope == @to_recipient_tags || scope == @occasion_tags
        if @primary_array.include?(tag.id)
          checked = "checked"
        else
          checked = nil
        end
        concat "<input id='story_classifications_attributes_0_primary' value='#{tag.id}' name='story[classifications_attributes][0][primary][#{tag_name}][]' type='radio' #{checked}>".html_safe
      end
    end
    
    #method to add un/checked checkboxes to form
    def add_checkbox(scope, tag, tag_name) 
      if @tag_array.include?(tag.id)
        checked = "checked"
      else
        checked = nil
      end
      unless tag.name == "other"
        concat "<div style='display: block;'><input id='story_classifications_attributes_0_tag_id_#{tag.id}' value='#{tag.id}' name='story[classifications_attributes][0][tag_id][]' type='checkbox' #{checked}><label for='story_classifications_attributes_0_family'>#{tag.name.humanize}</label>".html_safe
        @i += 1
        primary_tag(scope, tag, tag_name)
      else
        @j = tag
        @j_checked = checked
        @other_array.each do |other|
          if other[0] == @j.id
            @j_other = "value= "+ other[1].to_s.gsub(/ /,"&#32;")
          end
        end
      end
      if @i == scope.length-1 && !@j.nil?
        concat "</div><div style='display: block;'><input id='story_classifications_attributes_0_tag_id_#{@j.id}' value='#{@j.id}' name='story[classifications_attributes][0][tag_id][]' #{@j_checked} type='checkbox'><label for='story_classifications_attributes_0_family'>#{@j.name.humanize}</label><input id='story_classifications_attributes_0_description' name='story[classifications_attributes][0][description][]' type='text' #{@j_other}>".html_safe
        primary_tag(scope, @j, tag_name)
      end
      concat "</div>".html_safe
    end
    
    tag_scope_array.each do |scope|
#      print correct header
      case scope
      when @relationship_tags
        tag_name = "relationship"
        concat "<h4>Relationship</h4>".html_safe
      when @to_recipient_tags
        tag_name = "recipient"
        concat "<h4>Recipient</h4>".html_safe
        concat "<p>Must have one primary recipient.</p>".html_safe
      when @occasion_tags
        tag_name = "occasion"
        concat "<h4>Occasion</h4>".html_safe
        concat "<p>Must have one primary occasion.</p>".html_safe
      when @type_tags
        tag_name = "type"
        concat "<h4>Type of Gift</h4>".html_safe
      when @interests_tags
        tag_name = "interest"
        concat "<h4>Interests</h4>".html_safe
      when @gifton_reaction_tags
        tag_name = "gifton_reaction"
        concat "<h4>GiftOn's Reaction</h4>".html_safe
      when @collection_tags
        tag_name = "collection"
        concat "<h4>Collection</h4>".html_safe
      end
      @i = 0
      @j = nil
      scope.each do |tag|
        add_checkbox(scope, tag, tag_name)
      end
    end
  end
end