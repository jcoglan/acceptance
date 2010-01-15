class ArticlesController < ApplicationController
  layout 'application'
  
  def new
    @article = Article.new
    render :action => 'edit'
  end
  
  def edit
    @article = Article.first
  end
end

