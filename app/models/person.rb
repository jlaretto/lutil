class Person < ActiveRecord::Base
 attr_accessible :firstname, :lastname, :email

 has_many :relation_person_companies
 has_many :companies, through: :relation_person_companies
end
