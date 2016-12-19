class User < ActiveRecord::Base
  has_many :reviews
  has_secure_password
  validates_presence_of :full_name, :email
  validates_uniqueness_of :email
end