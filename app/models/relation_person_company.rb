class RelationPersonCompany < ActiveRecord::Base

  attr_accessible :person_id, :company_id

  belongs_to :person
  belongs_to :company

end
