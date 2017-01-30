class Admin::StoriesController < ApplicationController
#  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_admin
  before_action :set_story, only: [:show, :edit]
  before_action :set_tags, only: [:show, :index, :new, :edit]
  before_action :set_anonymous_user, only: [:update, :destroy, :show]
  
  def index
    @stories = Story.includes(:user).unpublished.active
  end
  
  def show
  end
  
  def edit
    @relationship_tags = @tags.select { |tag| tag.tag_category.category == "Relationship" }.sort_by {|t| t.name}
    @occasion_tags = @tags.select { |tag| tag.tag_category.category == "Occasion" }.sort_by {|t| t.name}
    @type_tags = @tags.select { |tag| tag.tag_category.category == "Type" }.sort_by {|t| t.name}
    @interests_tags = @tags.select { |tag| tag.tag_category.category == "Interests" }.sort_by {|t| t.name}
    @to_recipient_tags = @tags.select { |tag| tag.tag_category.category == "To_recipient" }.sort_by {|t| t.name}
    @gifton_reaction_tags = @tags.select { |tag| tag.tag_category.category == "Gifton_reaction" }.sort_by {|t| t.name}
    @collection_tags = @tags.select { |tag| tag.tag_category.category == "Collection" }.sort_by {|t| t.name}
  end
  
  def destroy
    @story = Story.find(params[:id])
    if @story.destroy
      destroy_notification(@story)
      flash[:success] = "Story has been deleted"
      redirect_to admin_stories_path
    end
  end
  
  def update
    @story = Story.includes(:classifications).find(params[:id])
    @story.validate_final_fields = true
    @story.validate_main_image = true
    @published_changed = nil 
    delete_old_tags(@story)
    
    if params[:story][:classifications_attributes]
      if params[:story][:classifications_attributes].to_unsafe_h.values[0].include?("tag_id")
        params[:story][:classifications_attributes].each {|index, parms| 
          parms[:tag_id].each { |tag|
            description= nil
            primary = false
            if parms[:description]
              if parms[:description][tag.to_s] != nil
                description = parms[:description][tag.to_s][0]
              end
            end
#            if parms[:primary]
              if parms[:primary][:recipient] || parms[:primary][:occasion]
                if parms[:primary][:recipient].include?(tag) || parms[:primary][:occasion].include?(tag)
                  primary = true
                end
              end
#            end
            @story.classifications.create(tag_id: tag, primary: primary, description: description)
          }
        }
      end
    end
    
    @story.validate_all_tags = true
    
    @story.admin_id = current_user[:id]
    unless @story.published? 
      @story.published = true
      @story.admin_published_at = DateTime.current
      @published_changed = true
    end
    unless @story.anonymous?
      @story.poster_id = @story.author_id
    else
      @story.poster_id = @anonymous_user.id
    end
    @story.last_user_to_update = "Admin"  
    respond_to do |format|
      if @story.update(story_params_standalone) #standalone params, otherwise incorrect classifications are created
        if @published_changed
          create_notification(@story)
        end
        flash[:success] = "Story has been updated"
        format.html {redirect_to admin_story_path(@story)}
      else
        flash.now[:alert] = "Story has not been updated"
        format.html {render :edit}
        format.js {render :partial => 'admin/stories/storyerrors', :data => @story.to_json }
      end
    end
  end
  
  private
  def story_params
    params.require(:story).permit(:final_title, :final_body, :final_gift_description, :published, :fail, :admin_published_at, :main_image, classifications_attributes: [:id, :story_id, :primary, :description => [], :tag_id => []])
  end
  
  def story_params_standalone
    params.require(:story).permit(:final_title, :final_body, :final_gift_description, :published, :fail, :admin_published_at, :main_image)
  end
  
  def require_admin
    unless current_user && current_user.admin?
      redirect_to root_path
      flash[:alert] = "Error."
    end
  end
  
  def set_story
    @story = Story.includes(:classifications, :user).find(params[:id])
  end
  
  def create_notification(story)
    #Notification to story author
    Notification.create(user_id: story.author_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 1,
                        read: false,
#                        origin_id: story.id,
                        story_id: story.id)
    
    #Notification for all people who follow the poster
    followings = Following.where(user_id: story.poster_id)
    followings.each do |follower|
      Notification.create(user_id: follower.follower_id,
                        notified_by_user_id: current_user.id,
                        notification_category_id: 1,
                        read: false,
#                        origin_id: story.id,
                        options: "followers",
                        story_id: story.id)
    end
  end
  def destroy_notification(story)
    unless Notification.where(story_id: story.id).empty?
      Notification.where(story_id: story.id).each(&:destroy)   
    end
  end
  
  def delete_old_tags(story)
    story.classifications.delete_all
  end
  
  def set_tags
    @tags = Tag.alltags
  end
  
  def set_anonymous_user
    @anonymous_user = User.where(anonymous: true).first
  end
end