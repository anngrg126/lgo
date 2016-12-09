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
  
  def admin_tag_story(array)
  
    def all_tag(tagvar, tag, tagcategory)
      # if tag[0] == "other"
      #   concat "</div><div style='display: block;'><input id='story_classifications_attributes_0_tag_id_#{tag[1]}' value='#{tag[1]}' name='story[classifications_attributes][0][tag_id][]' type='checkbox'><label for='story_classifications_attributes_0_family'>#{tag[0].humanize}</label><input id='story_classifications_attributes_0_description' name='story[classifications_attributes][0][description][]' type='text'>".html_safe
      # else
      #   concat "<div style='display: block;'><input id='story_classifications_attributes_0_tag_id_#{tag[1]}' value='#{tag[1]}' name='story[classifications_attributes][0][tag_id][]' type='checkbox'><label for='story_classifications_attributes_0_family'>#{tag[0].humanize}</label>".html_safe
      # end
      # if tagcategory == "recipient_tags" || tagcategory == "occasion_tags"
      #   concat "<input id='story_classifications_attributes_0_primary_recipient_tag_id_#{tag[1]}' value='#{tag[1]}' name='story[classifications_attributes][0][primary][#{tagcategory}][]' type='radio' required>".html_safe
      # end
      if tag["ctag"] == nil
        check_tag = nil
      else
        check_tag = "checked"
      end
      
      if tag["primary"] ==nil
        primary_tag = nil
      else
        primary_tag = "checked"
      end
      
      if tag["name"] == "other"
        concat "</div><div style='display: block;'><input id='story_classifications_attributes_0_tag_id_#{tag["id"]}' value='#{tag["id"]}' name='story[classifications_attributes][0][tag_id][]' type='checkbox' #{check_tag}><label for='story_classifications_attributes_0_family'>#{tag["name"].humanize}</label><input id='story_classifications_attributes_0_description' name='story[classifications_attributes][0][description][]' type='text'>".html_safe
      else
        concat "<div style='display: block;'><input id='story_classifications_attributes_0_tag_id_#{tag["id"]}' value='#{tag["id"]}' name='story[classifications_attributes][0][tag_id][]' type='checkbox' #{check_tag}><label for='story_classifications_attributes_0_family'>#{tag["name"].humanize}</label>".html_safe
      end
      if tagcategory == "recipient_tags" || tagcategory == "occasion_tags"
        concat "<input id='story_classifications_attributes_0_primary_recipient_tag_id_#{tag["id"]}' value='#{tag["id"]}' name='story[classifications_attributes][0][primary][#{tagcategory}][]' type='radio' required #{primary_tag}>".html_safe
      end
      
    end
    
    
    array.each do |tagvar|
      #print correct header
      tagcategory=nil
      case tagvar
      when @relationship_tags
        tagcategory = "relationship_tags"
        concat "<h4>Relationship</h4>".html_safe
      when @to_recipient_tags
        tagcategory = "recipient_tags"
        concat "<h4>Recipient</h4>".html_safe
        concat "<p>Must have one primary recipient.</p>".html_safe
      when @occasion_tags
        tagcategory = "occasion_tags"
        concat "<h4>Occasion</h4>".html_safe
        concat "<p>Must have one primary occasion.</p>".html_safe
      when @type_tags
        tagcategory = "type_tags"
        concat "<h4>Type of Gift</h4>".html_safe
      when @interests_tags
        tagcategory = "interests_tags"
        concat "<h4>Interests</h4>".html_safe
      when @gifton_reaction_tags
        tagcategory = "gifton_reaction_tags"
        concat "<h4>GiftOn's Reaction</h4>".html_safe
      when @collection_tags
        tagcategory = "collection_tags"
        concat "<h4>Collection</h4>".html_safe
      end
      
      i = 0
      j = nil
      tagvar.each do |tag|
        unless tag["name"] == "other"
          all_tag(tagvar, tag, tagcategory)
          i += 1
        else
          j = tag
        end
        if i == tagvar.length-1 && !j.nil?
          all_tag(tagvar, j, tagcategory)
        end
        
        concat "</div>".html_safe
      end
    end
  end
end