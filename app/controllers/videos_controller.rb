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

  def create_review

  end
end