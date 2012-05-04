class RelationPersonCompany < ActiveRecord::Base

  attr_accessible

  belongs_to :person
  belongs_to :company

end
