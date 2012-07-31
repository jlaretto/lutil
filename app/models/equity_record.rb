class EquityRecord < ActiveRecord::Base

  attr_accessible :amount, :equity_type, :capitalization_record, :capitalization_record_id, :capitalization_table, :person, :person_id, :equity_plan, :proforma_target_amount_type , :company, :company_id

  belongs_to :capitalization_record
  belongs_to :company

  belongs_to :person
  belongs_to :equity_plan

  validates :amount, :numericality => true
end
