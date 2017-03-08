class User < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(position: :asc) }
  has_many :relationships
  has_many :following_relationships, class_name: Relationship, foreign_key: :follower_id
  has_many :leading_relationships, class_name: Relationship, foreign_key: :leader_id
  has_many :sent_invitations, class_name: Invitation, foreign_key: :sender_id
  has_secure_password
  validates_presence_of :full_name, :email
  validates_uniqueness_of :email

  def normalize_positions
    queue_items.each_with_index do |item, idx|
      item.update_attributes( position: idx + 1 )
    end
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def follows?(other_user)
    !!existing_relationship(other_user)
  end

  def can_follow?(other_user)
    self != other_user && !self.follows?(other_user)
  end

  def existing_relationship(other_user)
    following_relationships.find_by(leader_id: other_user.id)
  end

  def queued_video?(video)
    queue_items.all.map(&:video).include?(video)
  end

  def generate_token
    self.update_column(:token, SecureRandom.urlsafe_base64)
  end

  def destroy_token
    self.update_column(:token, nil)
  end
end