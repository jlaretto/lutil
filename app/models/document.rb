class Document < ActiveRecord::Base
  attr_accessible :description, :document_type, :name, :company_id, :applicable_date

  belongs_to :company

end
