class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order(position: :asc) }
  has_secure_password
  validates_presence_of :full_name, :email
  validates_uniqueness_of :email

  def normalize_positions
    queue_items.each_with_index do |item, idx|
      item.update_attributes( position: idx + 1 )
    end
  end
end