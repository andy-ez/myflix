class Category < ActiveRecord::Base
  has_many :videos, -> { order(created_at: :desc) }
  validates_presence_of :title

  def recent_videos
    self.videos.first(6)
  end
end