class ArticlesController < ApplicationController
  layout 'application'
  
  def new
    @article = Article.new
  end
end

