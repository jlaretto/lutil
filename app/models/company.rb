class Company < ActiveRecord::Base
  attr_accessible :name, :street_address, :city_state_zip, :phone, :fax, :business_description

  validates :name, presence: true
  validates :street_address, presence: true
  validates :city_state_zip, presence: true
  validates :phone, presence: true


  has_many :relation_person_companies
  has_many :people, through: :relation_person_companies

end
