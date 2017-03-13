class VideosController < ApplicationController
  before_action :require_user
  
  def search
    @videos = Video.search_by_title(params[:title])
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
    @review = Review.new
  end

  def advanced_search
    options = {
      reviews: params[:reviews],
      rating_from: params[:rating_from],
      rating_to: params[:rating_to]
    }
    if params[:query].present?
      @videos = Video.search(params[:query], options).results
    else
      @videos = []
    end
  end

  def create_review

  end
end