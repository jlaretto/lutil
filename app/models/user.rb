class User < ActiveRecord::Base
  before_save :updateToken

  attr_accessible :password_digest, :email, :password_confirmation, :password

  has_secure_password

  belongs_to :person
  belongs_to :active_company, class_name: "Company", foreign_key: :active_company_id

  def self.authenticate(email, password)

      User.find_by_email(email).try(:authenticate, password)
  end

  # validates :presence, :email
  # validates :presence, :password_digest


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  def find_company_fuzzy( fuzzyname )

    matches = []

    #todo - Find Company Fuzzy needs serious work
    person.companies.each{|company| matches << company if company.name.downcase.include?(fuzzyname.downcase)}

    matches.length == 1 ? matches[0] : nil

  end




  private

  def updateToken()
    self.session_token = SecureRandom.urlsafe_base64
  end

end
