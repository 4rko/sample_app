# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEXP }, 
  					uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 } # has_secure_password zawiera walidację :password_digest, presence: true; gdyby tu była dodatkowo walidacja :password, presence: true, to przy wyświetlaniu błędów formularza na stronie byłyby dwa komunikaty dot. tego samego błędu 
  validates :password_confirmation, presence: true

  has_secure_password

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
