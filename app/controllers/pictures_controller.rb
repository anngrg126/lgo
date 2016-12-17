class PicturesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_story
  before_action :set_picture, only: [:edit, :update, :destroy]
  before_action :set_tags, only: [:show, :index, :new, :edit]
  
  def new
    @story = Story.find(params[:story_id])
    @picture = @story.pictures.build(:image => params[:image])
  end
  
  def create
    @story = Story.find(params[:story_id])
    if params[:image]
      params[:image].each { |image|
        @picture = @story.pictures.create(image: image)
      }
    else
      @picture = @story.pictures.build()
      @picture.validate_story_image = true
    end
    respond_to do |format|
      if @picture.save
        flash[:success] = "Success"
        format.html { redirect_to story_path(@story) }
      else
        flash.now[:alert] = "Picture has not been uploaded."
        format.html {render :new}
        format.js {render :partial => 'pictures/pictureerrors', :data => @picture.to_json }
      end  
    end
  end
  
  def destroy
    @picture = Picture.find(params[:id])
    @story = Story.find(@picture.story_id)
    if @picture.destroy
      redirect_to story_path(@story)
    end
  end
  
  private 
  
  def picture_params
#    params.require(:picture).permit(:story_id, :image)
  end
  
  def set_story
    @story = Story.find(params[:story_id])
  end
  
  def set_picture
    @picture = Picture.find(params[:id])
  end
  
  def set_tags
    @tags = Tag.all.group_by(&:name)
  end
  
end