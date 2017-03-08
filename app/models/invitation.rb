class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: User
  validates_presence_of :recipient_name, :recipient_email
  validates_uniqueness_of :recipient_email

  before_create { self.token = SecureRandom.urlsafe_base64 }

  def destroy_token
    self.update_column(:token, nil)
  end
end