class Document < ActiveRecord::Base
  attr_accessible :description, :document_type, :name, :company_id, :applicable_date, :aws_key

  belongs_to :company

  has_many :document_tags

end
