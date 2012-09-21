class DocumentTagType < ActiveRecord::Base
  attr_accessible  :name, :description, :mandatory_tags, :suggested_tags, :type, :company_id, :company

  belongs_to :company
end
