class PagesController < ApplicationController
  before_action :set_tags
  
  def terms
  end

  def contacts
  end
  
  def set_tags
    @tags = Tag.alltags
  end
end
