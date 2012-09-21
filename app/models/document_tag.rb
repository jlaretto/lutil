class DocumentTag < ActiveRecord::Base

  belongs_to :document
  belongs_to :document_tag_type


end
