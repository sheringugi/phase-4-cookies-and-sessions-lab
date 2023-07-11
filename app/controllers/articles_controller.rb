class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  def show_article
    session[:page_views] ||= 0
    session[:page_views] += 1
  
    if session[:page_views] < 3
      # Render JSON response with article data
      render json: { article: { id: params[:id], title: 'Sample Article' } }
    else
      # Render JSON response with error message and status code 401
      render json: { error: 'You have reached the maximum number of page views.' }, status: 401
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
