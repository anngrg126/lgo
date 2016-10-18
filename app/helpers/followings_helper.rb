module FollowingsHelper
  def link_to_follow(user, follower, classes)
    
#    already_follows = current_user && current_user.follows?(user)
#    method_name =  already_follows ? :delete : :post 
#    link_text = already_follows ? "Unfollow" : "Follow"  
#    follower_id = current_user ? follower.id : 0
    
    unless current_user
      link_to "Follow", followings_path(user_id: user.id, follower_id: 0), method: :post, class: "button"
    else
      if current_user.follows?(user)
        link_to "Unfollow", following_path(Following.find_by(user_id: user.id, follower_id: follower.id)), method: :delete, class: classes, remote: true
      else
        unless user == follower
          link_to "Follow", followings_path(user_id: user.id, follower_id: follower.id), method: :post, class: classes, remote: true
        end
      end
    end
  end
end