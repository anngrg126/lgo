class Admin::StoriesController < ApplicationController
#  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_admin
  before_action :set_story, only: [:update, :destroy]
  
  def index
    @stories = Story.unpublished.active
  end
  
  def show
    @story = Story.includes(:classifications).find(params[:id])
  end
  
  def edit
    @story = Story.includes(:classifications).find(params[:id])
    
    @relationship_tags = Tag.relationship.order(name: :asc)
    @occasion_tags = Tag.occasion.order(name: :asc)
    @type_tags = Tag.type.order(name: :asc)
    @interests_tags = Tag.interests.order(name: :asc)
    @to_recipient_tags = Tag.recipient.order(name: :asc)
    @gifton_reaction_tags = Tag.gifton_reaction.order(name: :asc)
    @collection_tags = Tag.collection.order(name: :asc)
  end
  
  def destroy
    if @story.destroy
      destroy_notification(@story)
      flash[:success] = "Story has been deleted"
      redirect_to admin_stories_path
    end
  end
  
  def update
    @story.validate_final_fields = true
    @story.validate_main_image = true
    @published_changed = nil 
    delete_old_tags(@story)
    i = 0
    if params[:story][:classifications_attributes]
      if params[:story][:classifications_attributes].to_unsafe_h.values[0].include?("tag_id")
        params[:story][:classifications_attributes].each {|index, parms| 
          parms[:tag_id].each { |tag|
            if @story.classifications.where(tag_id: tag).empty?
              @classification = @story.classifications.create(tag_id: tag)
              if parms[:description]
                parms[:description].delete_if{|i|i==""}
                if Tag.find(tag).name == "other"
                  @classification.update(description: parms[:description][i])
                  i +=1
                end
              end
              if parms[:primary]
                if parms[:primary][:recipient] || parms[:primary][:occasion]
                  if parms[:primary][:recipient].include?(tag) || parms[:primary][:occasion].include?(tag)
                    @classification.update(primary: true)
                  end
                end
              end
            end
          }
        }
      end
    end
    
    unless @story.classifications.empty?
      @story.validate_all_tags = true
    end
    
    @story.admin_id = current_user[:id]
    unless @story.published? 
      @story.published = true
      @story.admin_published_at = DateTime.current
      @published_changed = true
    end
    unless @story.anonymous?
      @story.poster_id = @story.author_id
    else
      @story.poster_id = 3
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
    params.require(:story).permit(:final_title, :final_body, :published, :admin_published_at, :main_image, classifications_attributes: [:id, :story_id, :primary, :description => [], :tag_id => []])
  end
  
  def story_params_standalone
    params.require(:story).permit(:final_title, :final_body, :published, :admin_published_at, :main_image)
  end
  
  def require_admin
    unless current_user && current_user.admin?
      redirect_to root_path
      flash[:alert] = "Error."
    end
  end
  
  def set_story
    @story = Story.find(params[:id])
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
    unless Classification.where(story_id: story.id).empty?
       Classification.where(story_id: story.id).each(&:destroy)   
    end
  end
end