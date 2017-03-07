module MailerHelper  
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
    @mailer=true
    
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
    # n_users.push(current_user.id)
     n_users.uniq!
     @n_users = User.where(id: n_users)
    
    #begin consolidating notifications
    notifications_array.each do |n|
      case n.notification_category.name
      when "Story"
        story = @n_stories.select{|s| s.id == n.story_id}.first
        link = link_to story.final_title, story_url(story), class: "bold-text-link", target: "_blank"
        noti_ids = []
        story_users=[]
        author = @n_users.select{|u| u.id == story.author_id}.first
        story_users.push(author)
        if n.options == "admin"
          # Story admin notification
          link_author = link_to author.full_name, dashboard_url(author), class: "bold-text-link", target: "_blank"
          noti_ids.push(n.id)
          my_message_admin = Hash.new
          my_message_admin["message_id"]=noti_ids
          my_message_admin["users"] = story_users
          my_message_admin["message"] = link_author+" updated a story where you are an admin. See it here: "+link
          my_message_admin["option"] = "admin"
          my_message_admin["category"] = "Story"
          my_message.push(my_message_admin)
        elsif n.options == "followers"
          # Story poster's followers notification
          poster = @n_users.select{|u| u.id == story.poster_id}.first
          link_poster = link_to poster.full_name, dashboard_url(poster), class: "bold-text-link", target: "_blank"
          noti_ids.push(n.id)
          my_message_follower = Hash.new
          my_message_follower["message_id"]=noti_ids
          my_message_follower["users"] = story.anonymous ? [@anonymous_user] : story_users
          my_message_follower["message"] = link_poster+" published a new story! See it here: "+link
          my_message_follower["option"] = "followers"
          my_message_follower["category"] = "Story"
          my_message.push(my_message_follower)
        else
          # Story author notification
          noti_ids.push(n.id)
          my_message_author = Hash.new
          my_message_author["message_id"]=noti_ids
          my_message_author["users"] = story_users
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
            commenter_links.push(link_to c.full_name, dashboard_url(c), class: "bold-text-link", target: "_blank")
            commenter_users.push(c)
          end
          my_message_comments["users"] = commenter_users
          
          link = link_to s.final_title, story_url(s), class: "bold-text-link", target: "_blank"
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
              reactor_links.push(link_to c.full_name, dashboard_url(c), class: "bold-text-link", target: "_blank")
              reaction_users.push(c)
            end
            my_message_reactions["users"] = reaction_users
            link = link_to s.final_title, story_url(s), class: "bold-text-link", target: "_blank"
            unless reactor_links.empty?
              if o == @like_reaction
                id_array.push(noti_ids)
                reaction_messages.push("#{reactor_links.to_sentence} liked your story #{link}")
              else
                id_array.push(noti_ids)
                reaction_messages.push("#{reactor_links.to_sentence} reacted to your story #{link}")
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
        link = link_to s.final_title, story_url(s), class: "bold-text-link", target: "_blank", target: "_blank"
        link_bookmark = link_to "bookmarked", bookmarked_stories_dashboard_url(@user), class: "bold-text-link", target: "_blank"
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
        follower_links.push(link_to f.full_name, dashboard_url(f), class: "bold-text-link", target: "_blank")
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
      if id_array[index].instance_of? Fixnum
        @max_index = id_array[index]
      else
        @max_index = id_array[index].max
      end
      @noti = notifications_array.select{|n| n.id == @max_index}.first
      unless index > my_message.length-1
        partial =  render partial: 'shared/notification_partial_email', locals: { my_message: my_message[index], time: time_ago_in_words(@noti.created_at), date: @noti.created_at.strftime("%b %d, %Y"), read: read_boolean}
      end
      output.push(partial)
    end
    return output.join(" ")
  end
end