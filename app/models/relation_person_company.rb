class RelationPersonCompany < ActiveRecord::Base

  attr_accessible :person_id, :company_id, :relation_type, :relation_detail

  belongs_to :person
  belongs_to :company

end
