class ArticlesController < ApplicationController
  def new
    @article = Article.new
  end
end

