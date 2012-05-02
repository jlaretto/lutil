class Company < ActiveRecord::Base
  has_many :relation_person_companies
  has_many :people, through: :relation_person_companies
end
