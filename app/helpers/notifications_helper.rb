module NotificationsHelper
#  helper to list individual notifications
#  def notification_text(notification)
#    notifier = User.find(notification.notified_by_user_id)
#    link_notifier = link_to notifier.full_name, dashboard_path(notifier)
#    
#    case notification.notification_category_id
#      
#    when 1 #Story
#      story = Story.find(notification.origin_id)
#      link = link_to story_title(story), story_path(story)
#      unless notification.options == "followers"
#        # Story author gets a notification
#        text = "Your story has been published! See it here: "+link
#      else
#        poster = User.find(story.poster_id)
#        link_poster = link_to poster.full_name, dashboard_path(poster)
#        # Poster followers get a notification
#        text = link_poster+" published a new story! See it here: "+link
#      end
#        
#    when 2 #Comment
#      story = Story.find(Comment.find(notification.origin_id).story_id)
#      link_story = link_to story_title(story), story_path(story)
#      
#      unless notification.options == "commenters"
#        # Story author gets a notification
#        text = link_notifier+" commented on your story, "+ link_story
#      else
#        # Other commenters get a notification
#        text = link_notifier+" also commented on "+ link_story
#      end 
#      
#    when 3 #Reaction
#      reaction = Reaction.find(notification.origin_id)
#      story = Story.find(reaction.story_id)
#      link = link_to story_title(story), story_path(story)
#      
#      case notification.options
#      when "1" #like
#        text = link_notifier+" liked your story, "+link
#      when "2" #omg
#        text = link_notifier+" OMG'd your story, "+link
#      when "3" #lol
#        text = link_notifier+" LOL'd your story, "+link
#      when "4" #cool
#        text = link_notifier+" Cool'd your story, "+link
#      else #5 - love 
#        text = link_notifier+" Loved your story, "+link
#      end
#      
#    when 4 #Bookmark
#      bookmark = Bookmark.find(notification.origin_id)
#      story = Story.find(bookmark.story_id)
#      link = link_to story_title(story), story_path(story)
#      # Story author gets a notification
#      text = "Woohoo! Someone bookmarked your story, "+link
#      
#    else #Following
#      text = link_notifier+ " followed you."
#    end
#  end
#  
  def consolidate_notifications(notifications_array, read_boolean)
    stories_comments_author = []
    stories_comments_commenters = []
    stories_comments = []
    stories_bookmarks = []
    stories_reactions = []
    followers = []
    messages = []
    id_array = []
    call_functions = []
    @followers_id_array = []
    
    notifications_array.each do |n|
      case n.notification_category_id
      when 1
        story = Story.find(n.origin_id)
        link = link_to story_title(story), story_path(story)
        ids = []
        if n.options == "admin"
          # Story admin notification
          author = User.find(story.author_id)
          link_author = link_to author.full_name, dashboard_path(author)
          messages.push(link_author+" updated a story where you are an admin. See it here: "+link)
          ids.push(n.id)
        elsif n.options == "followers"
          poster = User.find(story.poster_id)
          link_poster = link_to poster.full_name, dashboard_path(poster)
          # Story poster's followers notification
          messages.push(link_poster+" published a new story! See it here: "+link)
          ids.push(n.id)
        else
          # Story author notification
          messages.push("Your story has been published! See it here: "+link)
          ids.push(n.id)
        end
        id_array.push(ids)
      when 2
        stories_comments.push(Story.find(Comment.find(n.origin_id).story_id))
        call_functions.push("comments_condense")
      when 3
        stories_reactions.push(Story.find(Reaction.find(n.origin_id).story_id))        
        call_functions.push("reactions_condense")
      when 4
        stories_bookmarks.push(Story.find(Bookmark.find(n.origin_id).story_id))
        call_functions.push("bookmarks_consense")
      else
        followers.push(n.id)
        followers.push(User.find(n.notified_by_user_id))
        call_functions.push("followings_condense")
      end
    end
    call_functions.uniq
    
    if call_functions.include?("comments_condense")
      optionsarray = [nil, "commenters"]
      stories_comments.uniq.each do |s|
        optionsarray.each do |o|
          ids = []
          commenters = []
          unless notifications_array.where(notification_category_id: 2, options: o).empty?
            notifications_array.where(notification_category_id: 2, options: o).each do |n|
              if Comment.find(n.origin_id).story_id == s.id
                commenters.push(User.find(n.notified_by_user_id))
                ids.push(n.id)
              end
            end
            commenter_links = []
            commenters.uniq.each do |c|
              commenter_links.push(link_to c.full_name, dashboard_path(c))
            end 
            link = link_to story_title(s), story_path(s)
            unless commenter_links.empty?
              if o == nil
                messages.push("#{commenter_links.to_sentence} commented on your story #{link}")
                id_array.push(ids)
              else
                messages.push("#{commenter_links.to_sentence} also commented on #{link}")
                id_array.push(ids)
              end
            end
          end
        end
      end
    end
    
    if call_functions.include?("reactions_condense")
      optionsarray = ["1", "2", "3", "4", "5"]
      stories_reactions.uniq.each do |s|
        reactors = []
        optionsarray.each do |o|
          ids = []
          unless notifications_array.where(notification_category_id: 3, options: o).empty?
            notifications_array.where(notification_category_id: 3, options: o).each do |n|
              if Reaction.find(n.origin_id).story_id == s.id
                reactors.push(User.find(n.notified_by_user_id))
                ids.push(n.id)
              end
            end
            reactor_links = []
            reactors.uniq.each do |c|
              reactor_links.push(link_to c.full_name, dashboard_path(c))
            end 
            link = link_to story_title(s), story_path(s)
            unless reactor_links.empty?
              if o == "1"#like
                messages.push("#{reactor_links.to_sentence} liked your story #{link}")
                id_array.push(ids)
              elsif o == "2"#OMG
                messages.push("#{reactor_links.to_sentence} OMG'd your story #{link}")
                id_array.push(ids)
                elsif o == "3"#LOL
                messages.push("#{reactor_links.to_sentence} LOL'd your story #{link}")
                id_array.push(ids)
              elsif o == "4"#Cool
                messages.push("#{reactor_links.to_sentence} Cool'd your story #{link}")
                id_array.push(ids)
              elsif o == "5"#Love
                messages.push("#{reactor_links.to_sentence} Loved your story #{link}") 
                id_array.push(ids)
              end
            end
          end
        end
      end
    end
    
    if call_functions.include?("bookmarks_consense")
      #Case 4: Aggregate commenters on stories where user commented into one sentence
      stories_bookmarks.uniq.each do |s|
        bookmarkers = []
        ids = []
        notifications_array.where(notification_category_id: 4).each do |n|
          if Bookmark.find(n.origin_id).story_id == s.id
            bookmarkers.push(User.find(n.notified_by_user_id))
            ids.push(n.id)
          end
        end        
        bookmarker_links = []
        bookmarkers = bookmarkers.uniq.count
        
        link = link_to story_title(s), story_path(s)
        link_bookmark = link_to "bookmarked", bookmarked_stories_dashboard_path(current_user)
        if bookmarkers == 1 
          messages.push("Woohoo! Someone #{link_bookmark} your story #{link}")
          id_array.push(ids)
        else
          messages.push("Woohoo! #{bookmarkers} people #{link_bookmark} your story #{link}")
          id_array.push(ids)
        end
      end      
    end

    if call_functions.include?("followings_condense")
      #Case 5: Aggregate followers into one sentence
      follower_links = []
      ids = []
      followers.uniq
      ids = followers.find_all {|x| x.instance_of? Fixnum}
      followers = followers.find_all {|x| !x.instance_of? Fixnum}
      followers.each do |f|
        follower_links.push(link_to f.full_name, dashboard_path(f))
      end
      messages.push("#{follower_links.to_sentence} followed you")
      id_array.push(ids)
    end
    
    #All together here
    ordered_ids = []
    ordered_ids = id_array.sort_by{|x| x.max}
    ordered_ids.reverse!
    messages.uniq!
    index = -1
    output = [""]
      
    ordered_ids.each do |i|     
      index = id_array.index(i)
      output.push(content_tag(:div) {
        if id_array[index].instance_of? Fixnum
          @max_index = id_array[index]
        else
          @max_index = id_array[index].max
        end
        @noti = Notification.find(@max_index)
        concat "<div id='#{id_array[index]}'>".html_safe
        concat "<div>".html_safe
        safe_concat messages[index]
        concat "</div>".html_safe
        concat "<div>#{time_ago_in_words(@noti.created_at)} ago</div>".html_safe
        if read_boolean == "false"
          concat "<div class='unread'>UNREAD</div>".html_safe
          concat "<div class='mark_as_read'>#{link_to("Mark as read", mark_as_read_array_path(notification: id_array[index]), remote: true)}</div>".html_safe
        end
        concat link_to("Delete", notification_path(notification: id_array[index]), method: :delete, remote: true)
        concat "</div>".html_safe
      })
    end
    return output.join(" ")
  end
end