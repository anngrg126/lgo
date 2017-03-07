class Devise::UserUnlocksController < Devise::UnlocksController
  before_action :set_tags, only: [:show, :index, :new, :edit]

  private
  def set_tags
    @tags = Tag.alltags
  end

end