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
    stories_comments = []
    stories_bookmarks = []
    stories_reactions = []
    followers = []
    id_array = []
    @followers_id_array = []  
    my_message = []
    # my_message[0]["message_id"]
    # my_message[0]["users"]
    # my_message[0]["message"]
    # my_message[0]["category"]
    # my_message[0]["option"]
    
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
        noti_ids = []
        author = @n_users.select{|u| u.id == story.author_id}.first
        if n.options == "admin"
          # Story admin notification
          link_author = link_to author.full_name, dashboard_path(author)
          noti_ids.push(n.id)
          my_message_admin = Hash.new
          my_message_admin["message_id"]=noti_ids
          my_message_admin["users"] = author
          my_message_admin["message"] = link_author+" updated a story where you are an admin. See it here: "+link
          my_message_admin["option"] = "admin"
          my_message_admin["category"] = "Story"
          my_message.push(my_message_admin)
        elsif n.options == "followers"
          # Story poster's followers notification
            poster = @n_users.select{|u| u.id == story.poster_id}.first
          link_poster = link_to poster.full_name, dashboard_path(poster)
          noti_ids.push(n.id)
          my_message_follower = Hash.new
          my_message_follower["message_id"]=noti_ids
          my_message_follower["users"] = author
          my_message_follower["message"] = link_poster+" published a new story! See it here: "+link
          my_message_follower["option"] = "followers"
          my_message_follower["category"] = "Story"
          my_message.push(my_message_follower)
        else
          # Story author notification
          noti_ids.push(n.id)
          my_message_author = Hash.new
          my_message_author["message_id"]=noti_ids
          my_message_author["users"] = author
          my_message_author["message"] = "Your story has been published! See it here: "+link
          my_message_author["option"] = "published"
          my_message_author["category"] = "Story"
          my_message.push(my_message_author)
        end
        id_array.push(noti_ids)
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
        my_message_comments = Hash.new
        my_message_comments["category"]="Comment"
        commenter_messages=[]
        commenter_users=[]
        noti_ids=[]
        optionsarray.each do |o|
          commenters = []
          commenter_links = []
          
          unless notifications_array.select{|n| n.notification_category.name == "Comment" && n.options == o && n.story_id == s.id}.empty?
            notifications_array.select{|n| n.notification_category.name == "Comment" && n.options == o && n.story_id == s.id}.each do |n|
              commenters.push(@n_users.select{|u| u.id == n.notified_by_user_id}.first)
              noti_ids.push(n.id)
            end
          end
          my_message_comments["message_id"]= noti_ids
          
          commenters.uniq.each do |c|
            commenter_links.push(link_to c.full_name, dashboard_path(c))
            commenter_users.push(c)
          end
          my_message_comments["users"] = commenter_users
          
          link = link_to story_title(s), story_path(s)
          unless commenter_links.empty?
            if o == nil
              id_array.push(noti_ids)
              commenter_messages.push("#{commenter_links.to_sentence} commented on your story #{link}")
            else
              id_array.push(noti_ids)
              commenter_messages.push("#{commenter_links.to_sentence} also commented on #{link}")
            end
          end
          my_message_comments["message"] = commenter_messages[0]
          my_message_comments["option"] = 0
        end
        
        my_message.push(my_message_comments)
      end
    end
    
    unless notifications_array.select{|n| n.notification_category.name == "Reaction"}.empty?
      @reaction_categories = ReactionCategory.all
      @love_reaction = @reaction_categories.select{|r| r.name=="love"}.first
      @like_reaction = @reaction_categories.select{|r| r.name=="like"}.first 
      @omg_reaction = @reaction_categories.select{|r| r.name=="omg"}.first
      @lol_reaction = @reaction_categories.select{|r| r.name=="lol"}.first
      @cool_reaction = @reaction_categories.select{|r| r.name=="cool"}.first
      stories_reactions.uniq.each do |s|
        @reaction_categories.each do |o|
          reaction_messages=[]
          reaction_users=[]
          noti_ids=[]
          reactors = []
          reactor_links = []
          unless notifications_array.select{|n| n.notification_category.name == "Reaction" && n.options==o.id.to_s && n.story_id == s.id}.empty?
            notifications_array.select{|n| n.notification_category.name == "Reaction" && n.options==o.id.to_s && n.story_id == s.id}.each do |n|
              reactors.push(@n_users.select{|u| u.id == n.notified_by_user_id}.first)
              noti_ids.push(n.id)
            end
            my_message_reactions = Hash.new
            my_message_reactions["category"]="Reaction"
            my_message_reactions["option"]=o.name
            my_message_reactions["message_id"]= noti_ids
            reactors.uniq.each do |c|
              reactor_links.push(link_to c.full_name, dashboard_path(c))
              reaction_users.push(c)
            end
            my_message_reactions["users"] = reaction_users
            link = link_to story_title(s), story_path(s)
            unless reactor_links.empty?
              if o == @like_reaction
                id_array.push(noti_ids)
                reaction_messages.push("#{reactor_links.to_sentence} liked your story #{link}")
              elsif o == @omg_reaction
                id_array.push(noti_ids)
                reaction_messages.push("#{reactor_links.to_sentence} OMG'd your story #{link}")
              elsif o == @lol_reaction
                id_array.push(noti_ids)
                reaction_messages.push("#{reactor_links.to_sentence} LOL'd your story #{link}")
              elsif o == @cool_reaction
                id_array.push(noti_ids)
                reaction_messages.push("#{reactor_links.to_sentence} Cool'd your story #{link}")
              elsif o == @love_reaction
                id_array.push(noti_ids)
                reaction_messages.push("#{reactor_links.to_sentence} Loved your story #{link}") 
              end
            end
            my_message_reactions["message"] = reaction_messages[0]
          end
          unless my_message_reactions.nil?
            my_message.push(my_message_reactions)
          end
        end
      end
    end
    
    unless notifications_array.select{|n| n.notification_category.name == "Bookmark"}.empty?
      stories_bookmarks.uniq.each do |s|
        my_message_bookmarks = Hash.new
        my_message_bookmarks["category"]="Bookmark"
        bookmarks_messages=[]
        bookmarks_users=[]
        noti_ids=[]
        bookmarkers = []
        unless notifications_array.select{|n| n.notification_category.name == "Bookmark" && n.story_id == s.id}.empty?
          notifications_array.select{|n| n.notification_category.name == "Bookmark" && n.story_id == s.id}.each do |n|
            bookmarkers.push(@n_users.select{|u| u.id == n.notified_by_user_id}.first)
            noti_ids.push(n.id)
          end
        end
        my_message_bookmarks["message_id"]= noti_ids
        
        bookmarkers.uniq.each do |b|
            bookmarks_users.push(b)
        end
        bookmarkers = bookmarkers.uniq.count
        my_message_bookmarks["users"] = bookmarks_users
        link = link_to story_title(s), story_path(s)
        link_bookmark = link_to "bookmarked", bookmarked_stories_dashboard_path(current_user)
        if bookmarkers == 1 
          id_array.push(noti_ids)
          bookmarks_messages.push("Woohoo! Someone #{link_bookmark} your story #{link}")
        else
          id_array.push(noti_ids)
          bookmarks_messages.push("Woohoo! #{bookmarkers} people #{link_bookmark} your story #{link}")
        end
        my_message_bookmarks["message"] = bookmarks_messages[0]
        my_message_bookmarks["option"] = 0
        unless my_message_bookmarks.nil?
          my_message.push(my_message_bookmarks)
        end
      end 
    end

    unless notifications_array.select{|n| n.notification_category.name == "Following"}.empty?
      my_message_followers = Hash.new
      my_message_followers["category"]="Following"
      followers_messages=[]
      followers_users=[]
      noti_ids=[]
      
      follower_links = []
      followers.uniq
      ids = followers.find_all {|x| x.instance_of? Fixnum}
      followers = followers.find_all {|x| !x.instance_of? Fixnum}
      noti_ids= ids
      my_message_followers["message_id"]= noti_ids
      
      followers.each do |f|
        follower_links.push(link_to f.full_name, dashboard_path(f))
        followers_users.push(f)
      end
      my_message_followers["users"] = followers_users
      
      followers_messages.push("#{follower_links.to_sentence} followed you")
      my_message_followers["message"] = followers_messages[0]
      my_message_followers["option"] = 0
      id_array.push(noti_ids)
      unless my_message_followers.nil?
        my_message.push(my_message_followers)
      end
    end
    
    #All together here
    ordered_ids = []
    ordered_ids = id_array.sort_by{|x| x.max}
    ordered_ids.reverse!
    
    my_message.uniq!
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
        
        unless index > my_message.length-1
          partial =  render partial: 'shared/notification_partial', locals: { my_message: my_message[index], time: time_ago_in_words(@noti.created_at), read: read_boolean}
          concat "#{partial}".html_safe
          concat "</div>".html_safe
        end
      })
    end
    return output.join(" ")
  end
end