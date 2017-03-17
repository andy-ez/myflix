class VideoSearchDecorator
  attr_reader :video
  def initialize(video)
    @video = video
  end

  def id
    video.id
  end

  def small_cover
    video.small_cover
  end

  def title
    video.try(:highlight).try(:title) ? video.highlight[:title][0].html_safe : video.title
  end

  def description
    video.try(:highlight).try(:description) ? video.highlight[:description][0].html_safe : video.description
  end

  def average_rating
    video.average_rating
  end

  def reviews
    video.reviews
  end

  def last_review
    return "There are currently no reviews" unless video.reviews.any?
    if video.try(:highlight).try('reviews.content') 
      video.highlight['reviews.content'][0].html_safe 
    else
      video.reviews.last.content
    end
  end
end
