class Company < ActiveRecord::Base
  attr_accessible :name, :street_address, :city_state_zip, :phone, :fax, :business_description

  validates :name, presence: true
  validates :street_address, presence: true
  validates :city_state_zip, presence: true
  validates :phone, presence: true


  has_many :relation_person_companies

  has_many :status_updates

  has_many :documents

  #uniq collapses redundant records created by multiple relationships
  has_many :people, through: :relation_person_companies, uniq: true

  has_many :capitalization_records
  has_many :equity_records
  has_many :equity_plans

  def retrieve_document( docType)
      #documents.where("document_type = #{docType}")
      docs = documents.where(document_type: docType)
      return nil if docs.length == 0
      return docs[0]
  end

  def Charter
    retrieve_document (Constants::DOCUMENTTYPE_CHARTER)
  end

  def Bylaws

  end

  def Directors

  end

  def Officers

  end


end
