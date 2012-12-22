class StatusUpdate < ActiveRecord::Base
  attr_accessible   :company, :user, :description, :related_objects
  belongs_to :company
  belongs_to :user

  def self.AddDocumentStatusUpdate (company, document, description)
    raise "No valid document provided [StatusUpdate.AddDocumentStatusUpdate" unless document.present? && document.kind_of?(Document)
    relatedObject = "ver1||document|#{document.id}|"
    StatusUpdate.create(company: company, related_objects: relatedObject, description: description).save!
  end

  #related_objects format
  #v1 = "<version>||<objtype>|<id>||<2ndobjtype>|<2ndid>"

end
