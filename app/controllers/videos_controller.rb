class VideosController < ApplicationController

  def search
    @videos = Video.search_by_title(params[:title])
  end

  def show
    @video = Video.find(params[:id])
  end
end