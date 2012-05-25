class Person < ActiveRecord::Base
 attr_accessible :first_name, :last_name, :email, :middle_name, :street_address, :city_state_zip, :country, :phone

 has_many :relation_person_companies
 has_many :companies, through: :relation_person_companies
 has_many :equity_records

 validates :first_name, :last_name, :street_address, :city_state_zip, presence: true
 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
end
