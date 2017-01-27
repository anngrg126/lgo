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
#  helper to consolidate all notifications
  def consolidate_notifications(notifications_array, read_boolean)
    n_stories = []
    n_users = []
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
    
    #consolidate all stories to avoid N+1 db queries
    notifications_array.each do |n|
      n_stories.push(n.story_id) unless n.story_id == nil
    end
    n_stories.uniq!
    @n_stories = Story.where(id: n_stories)
    
    #consolidate all story posters to avoid N+1 db queries
    notifications_array.each do |n|
      n_users.push(n.notified_by_user_id)
    end
    n_users.uniq!
    @n_users = User.where(id: n_users)
    
    #begin consolidating notifications
    notifications_array.each do |n|
      case n.notification_category.name
      when "Story"
        story = @n_stories.select{|s| s.id == n.story_id}.first
        link = link_to story_title(story), story_path(story)
        ids = []
        if n.options == "admin"
          # Story admin notification
          author = @n_users.select{|u| u.id == story.author_id}.first
          link_author = link_to author.full_name, dashboard_path(author)
          messages.push(link_author+" updated a story where you are an admin. See it here: "+link)
          ids.push(n.id)
        elsif n.options == "followers"
          # Story poster's followers notification
#          unless story.anonymous?
            poster = @n_users.select{|u| u.id == story.poster_id}.first
#          else
#            poster = @anonyous_user
#          end
          link_poster = link_to poster.full_name, dashboard_path(poster)
          messages.push(link_poster+" published a new story! See it here: "+link)
          ids.push(n.id)
        else
          # Story author notification
          messages.push("Your story has been published! See it here: "+link)
          ids.push(n.id)
        end
        id_array.push(ids)
      when "Comment"
        stories_comments.push(@n_stories.select{|s| s.id == n.story_id}.first)
      when "Reaction"
        stories_reactions.push(@n_stories.select{|s| s.id == n.story_id}.first)
      when "Bookmark"
        stories_bookmarks.push(@n_stories.select{|s| s.id == n.story_id}.first)
      else
        followers.push(n.id)
        followers.push(@n_users.select{|u| u.id == n.notified_by_user_id}.first)
      end
    end
    
    unless notifications_array.select{|n| n.notification_category.name == "Comment"}.empty?
      optionsarray = [nil, "commenters"]
      stories_comments.uniq.each do |s|
        optionsarray.each do |o|
          commenters = []
          ids = []
          commenter_links = []
          unless notifications_array.select{|n| n.notification_category.name == "Comment" && n.options == o && n.story_id == s.id}.empty?
            notifications_array.select{|n| n.notification_category.name == "Comment" && n.options == o && n.story_id == s.id}.each do |n|
              commenters.push(@n_users.select{|u| u.id == n.notified_by_user_id}.first)
              ids.push(n.id)
            end
          end
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
    
    unless notifications_array.select{|n| n.notification_category.name == "Reaction"}.empty?
      optionsarray = ["1", "2", "3", "4", "5"]
      stories_reactions.uniq.each do |s|
        optionsarray.each do |o|
          reactors = []
          ids = []
          reactor_links = []
          unless notifications_array.select{|n| n.notification_category.name == "Reaction" && n.options==o && n.story_id == s.id}.empty?
            notifications_array.select{|n| n.notification_category.name == "Reaction" && n.options==o && n.story_id == s.id}.each do |n|
              reactors.push(@n_users.select{|u| u.id == n.notified_by_user_id}.first)
              ids.push(n.id)
            end
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
    
    unless notifications_array.select{|n| n.notification_category.name == "Bookmark"}.empty?
      stories_bookmarks.uniq.each do |s|
        bookmarkers = []
        ids = []
        unless notifications_array.select{|n| n.notification_category.name == "Bookmark" && n.story_id == s.id}.empty?
          notifications_array.select{|n| n.notification_category.name == "Bookmark" && n.story_id == s.id}.each do |n|
            bookmarkers.push(@n_users.select{|u| u.id == n.notified_by_user_id}.first)
            ids.push(n.id)
          end
        end
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

    unless notifications_array.select{|n| n.notification_category.name == "Following"}.empty?
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
        @noti = notifications_array.select{|n| n.id == @max_index}.first
        unless index > messages.length-1
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
        end
      })
    end
    return output.join(" ")
  end
end