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
#      link = link_to "#{User.find(story.poster_id).full_name}", dashboard_path(User.find(story.poster_id))
      unless story.anonymous?
        @s_user = story.user
#        link = link_to "#{story.user.full_name}", dashboard_path(story.user))
      else
        @s_user = @anonymous_user
#        link = link_to "#{User.find(story.poster_id).full_namy}", dashboard_path(User.find(story.poster_id))
      end
      link = link_to "#{@s_user.full_name}", dashboard_path(@s_user)
      partial =  render partial: 'followings/form', locals: { user: @s_user, follower: current_user }
      html = "<div>Posted by: #{link}</div><div>#{partial}</div>".html_safe
     
    else
      if story.anonymous?
        html = "<div>Posted by: Anonymous</div>"
      else
        link = link_to "#{story.user.full_name}", dashboard_path(story.user)
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
    
    @tag_array = story.classifications.select { |c| c.tag_id != nil  }   
    @primary_array = story.classifications.select { |c| c.primary == true }
    @other_array = story.classifications.select { |c| c.description != nil }
    
    if @story.fail?
      @tag_array
    end
   
    #method to add un/checked radio buttons to form
    def primary_tag(scope, tag)
      if scope == @to_recipient_tags || scope == @occasion_tags
        if scope == @to_recipient_tags
          tag_name = "recipient"
        else
          tag_name = "occasion"
        end
        if @primary_array.any?{|x| x[:tag_id] == tag.id}
          radio_checked = "checked"
        else
          radio_checked = nil
        end
        concat "<input id='story_classifications_attributes_0_primary' value='#{tag.id}' name='story[classifications_attributes][0][primary][#{tag_name}][]' type='radio' #{radio_checked} required>".html_safe
      end
    end
    
    #method to add un/checked checkboxes to form
    def add_checkbox(scope, tag) 
      if @tag_array.any?{|x| x[:tag_id] == tag.id}
        checkbox_checked = "checked"
      else
        checkbox_checked = nil
      end
      if tag.name == "fail" && @story.fail?
        checkbox_checked = "checked"
      end
      unless tag.name == "other"
        concat "<div style='display: block;'><input id='story_classifications_attributes_0_tag_id_#{tag.id}' value='#{tag.id}' name='story[classifications_attributes][0][tag_id][]' type='checkbox' #{checkbox_checked}><label for='story_classifications_attributes_0_family'>#{tag.name.humanize}</label>".html_safe
        @i += 1
        primary_tag(scope, tag)
      else
        @other = tag
      end
      if @i == scope.length-1 && !@other.nil?
        if @other_array.any?{|x| x[:tag_id] == @other.id} 
          @other_classification = @other_array.find{|x| x[:tag_id] == @other.id} 
          other_description =  "value= "+ @other_classification.description.to_s.gsub(/ /,"&#32;")
          other_checked = "checked"
        else
          other_description = "value= "
          other_checked = nil
        end
        concat "</div><div style='display: block;'><input id='story_classifications_attributes_0_tag_id_#{@other.id}' value='#{@other.id}' name='story[classifications_attributes][0][tag_id][]' #{other_checked} type='checkbox'><label for='story_classifications_attributes_0_family'>#{@other.name.humanize}</label><input id='story_classifications_attributes_0_description' name='story[classifications_attributes][0][description][#{@other.id}][]' type='text' #{other_description}>".html_safe
        primary_tag(scope, @other)
      end
      concat "</div>".html_safe
    end
    
    tag_scope_array.each do |scope|
#      print correct header
      case scope
      when @relationship_tags
        concat "<h4>Relationship</h4>".html_safe
      when @to_recipient_tags
        concat "<h4>Recipient</h4>".html_safe
        concat "<p>Must have one primary recipient.</p>".html_safe
      when @occasion_tags
        concat "<h4>Occasion</h4>".html_safe
        concat "<p>Must have one primary occasion.</p>".html_safe
      when @type_tags
        concat "<h4>Type of Gift</h4>".html_safe
      when @interests_tags
        concat "<h4>Interests</h4>".html_safe
      when @gifton_reaction_tags
        concat "<h4>GiftOn's Reaction</h4>".html_safe
      when @collection_tags
        concat "<h4>Collection</h4>".html_safe
      end
      @i = 0
      @other = nil
      scope.each do |tag|
        add_checkbox(scope, tag)
      end
    end
  end
  
  def tag_search(tag_name)
    unless @tags.select{|name| name == tag_name}.empty?
      @tags.select{|name| name == tag_name}.first[1][0].name
    end
  end
  
end