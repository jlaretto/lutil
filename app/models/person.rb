class Person < ActiveRecord::Base
 has_many :relation_person_companies
 has_many :companies, through: :relation_person_companies
end
