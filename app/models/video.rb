class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title(search = "")
    search.blank? ? all : where('title iLIKE ?', "%#{search}%").order(created_at: :asc)
  end

end