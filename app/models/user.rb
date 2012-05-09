class User < ActiveRecord::Base
  before_save :updateToken

  attr_accessible :password_digest, :email, :name, :password_confirmation, :password

  has_secure_password

  belongs_to :person

  def self.authenticate(email, password)

      User.find_by_email(email).try(:authenticate, password)
  end

  # validates :presence, :email
  # validates :presence, :password_digest


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :password, presence: true
  validates :password_confirmation, presence: true

  private

  def updateToken()
    self.session_token = SecureRandom.urlsafe_base64
  end

end
