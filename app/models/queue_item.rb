class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_numericality_of :position, { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      new_review = Review.new(rating: new_rating, user: user, video: video)
      new_review.save(validate: false)
    end
  end

  def category_title
    category.title
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end

end